"""Controller for Loan endpoints."""

from typing import Sequence
from datetime import date, timedelta
from decimal import Decimal

from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.loan import LoanCreateDTO, LoanReadDTO, LoanUpdateDTO
from app.models import Loan
from app.repositories.loan import LoanRepository, provide_loan_repo


class LoanController(Controller):
    """Controller for loan management operations."""

    path = "/loans"
    tags = ["loans"]
    return_dto = LoanReadDTO
    dependencies = {"loans_repo": Provide(provide_loan_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_loans(
        self, 
        loans_repo: LoanRepository,
        loan_id: int | None = None,
        user_id: int | None = None,
        get_active: bool | None = None,
        get_overdue: bool | None = None
    ) -> Sequence[Loan]:
        """All search related to loans"""

        if loan_id:
            return loans_repo.list(id=loan_id) 
        if user_id:
            return loans_repo.get_user_loan_history(user_id)
        if get_active:
            return loans_repo.get_active_loans()
        if get_overdue:
            return loans_repo.get_overdue_loans()
        
    @get("/fine")
    async def get_fine(
        self,
        loans_repo: LoanRepository,
        loan_id: int,
    ) -> Decimal:
        """Get fine numerical value"""
        return loans_repo.calculate_fine(loan_id)
    
    @patch("/terminate")
    async def return_book(
        self,
        loans_repo: LoanRepository,
        loan_id: int,
    ) -> Loan:
        try:
            return loans_repo.return_book(loan_id)
        except ValueError as e:
            raise HTTPException(
                status_code=400,
                details=str(e)
            )
        
    
    @post("/", dto=LoanCreateDTO)
    async def create_loan(
        self,
        data: DTOData[Loan],
        loans_repo: LoanRepository,
    ) -> Loan:
        """Create a new loan."""
        loan_instance = data.create_instance()
        
        today = date.today()
        loan_instance.loan_dt = today
        loan_instance.due_dt = today + timedelta(days=14)

        return loans_repo.add(loan_instance)

    @patch("/{id:int}", dto=LoanUpdateDTO)
    async def update_loan(
        self,
        id: int,
        data: DTOData[Loan],
        loans_repo: LoanRepository,
    ) -> Loan:
        """Update a loan by ID."""
        loan, _ = loans_repo.get_and_update(match_fields="id", id=id, **data.as_builtins())

        return loan

    @delete("/{id:int}")
    async def delete_loan(self, id: int, loans_repo: LoanRepository) -> None:
        """Delete a loan by ID."""
        loans_repo.delete(id)
