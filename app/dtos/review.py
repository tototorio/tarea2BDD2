"""Data Transfer Objects for Review endpoints."""

from advanced_alchemy.extensions.litestar import SQLAlchemyDTO, SQLAlchemyDTOConfig

from app.models import Review


class ReviewReadDTO(SQLAlchemyDTO[Review]):
    """DTO for reading Review data."""

    config = SQLAlchemyDTOConfig(max_nested_depth=1)


class ReviewCreateDTO(SQLAlchemyDTO[Review]):
    """DTO for creating Reviews."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "user", "book", "review_dt"},
    )


class ReviewUpdateDTO(SQLAlchemyDTO[Review]):
    """DTO for updating Reviews with partial data."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "user_id", "book_id", "created_at", "updated_at", "user", "book", "review_dt"},
        partial=True,
    )