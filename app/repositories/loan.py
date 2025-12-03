"""Repository for Loan database operations."""
from typing import Sequence
from datetime import date
from decimal import Decimal

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy.orm import Session
from sqlalchemy import select, update


from app.models import Loan, LoanStatus, Book, User


class LoanRepository(SQLAlchemySyncRepository[Loan]):
    """Repository for loan database operations."""

    model_type = Loan

    def get_active_loans(self) -> Sequence[Loan]:
        stmt = select(Loan).where(Loan.status == LoanStatus.ACTIVE)

        result = self.session.execute(stmt)
        return result.scalars().all()
    
    def get_overdue_loans(self) -> Sequence[Loan]:
        stmt = (
            update(Loan)
            .where(Loan.due_dt < date.today(), Loan.status == LoanStatus.ACTIVE)
            .values(status=LoanStatus.OVERDUE)
            .returning(Loan)
        )

        result = self.session.execute(stmt)
        return result.scalars().all()
    
    def calculate_fine(self, loan_id: int) -> Decimal:
        loan = self.get(loan_id)
        
        overdue_days = (date.today() - loan.due_dt).days
        fine = Decimal(overdue_days*500)
        
        if (fine <= 0):
            return Decimal("0.00")
        else:
            return fine.quantize(Decimal("0.01"))
    
    def return_book(self, loan_id: int) -> Loan:
        loan = self.get(loan_id)
        
        if loan.status == LoanStatus.RETURNED:
            raise ValueError("El préstamo ya fué finalizado anteriormente.")
        
        loan.fine_amount = self.calculate_fine(loan_id)
        loan.status = LoanStatus.RETURNED
        loan.return_dt = date.today()

        stmt = (update(Book).where(Book.id == loan.book_id).values(stock=Book.stock + 1))
        self.session.execute(stmt)

        return self.update(loan)
        
    def get_user_loan_history(self, user_id: int) -> Sequence[Loan]:
        stmt = select(Loan).where(user_id == Loan.user_id).order_by(Loan.loan_dt.desc())

        result = self.session.execute(stmt)
        return result.scalars().all()
        

async def provide_loan_repo(db_session: Session) -> LoanRepository:
    """Provide loan repository instance with auto-commit."""
    return LoanRepository(session=db_session, auto_commit=True)
