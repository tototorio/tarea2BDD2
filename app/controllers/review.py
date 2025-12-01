"""Controller for Review endpoints."""

from typing import Sequence

from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData
from litestar.status_codes import HTTP_204_NO_CONTENT
from litestar.exceptions import HTTPException

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.review import ReviewCreateDTO, ReviewReadDTO, ReviewUpdateDTO
from app.models import Review
from app.repositories.review import ReviewRepository, provide_review_repo


class ReviewController(Controller):
    """Controller for review management operations."""

    path = "/reviews"
    tags = ["reviews"]
    return_dto = ReviewReadDTO
    dependencies = {"reviews_repo": Provide(provide_review_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_reviews(self, reviews_repo: ReviewRepository) -> Sequence[Review]:
        """Get all reviews."""
        return reviews_repo.list()

    @get("/{id:int}")
    async def get_review(self, id: int, reviews_repo: ReviewRepository) -> Review:
        """Get a review by ID."""
        return reviews_repo.get(id)

    @post("/", dto=ReviewCreateDTO)
    async def create_review(
        self,
        data: DTOData[Review],
        reviews_repo: ReviewRepository,
    ) -> Review:
        """Create a new review."""
        review_data = data.create_instance()

        #Checks if the rating is valid
        if review_data.rating < 1 or review_data.rating > 5:
            raise HTTPException(
                status_code=400,
                detail="El rating debe estar entre 1 y 5"
            )

        return reviews_repo.add(data.create_instance())

    @patch("/{id:int}", dto=ReviewUpdateDTO)
    async def update_review(
        self,
        id: int,
        data: DTOData[Review],
        reviews_repo: ReviewRepository,
    ) -> Review:
        """Update a review by ID."""
        review, _ = reviews_repo.get_and_update(match_fields="id", id=id, **data.as_builtins())

        return review

    @delete("/{id:int}", status_code=HTTP_204_NO_CONTENT)
    async def delete_review(self, id: int, reviews_repo: ReviewRepository) -> None:
        """Delete a review by ID."""
        reviews_repo.delete(id)
