"""Data Transfer Objects for Category endpoints."""

from advanced_alchemy.extensions.litestar import SQLAlchemyDTO, SQLAlchemyDTOConfig

from app.models import Category


class CategoryReadDTO(SQLAlchemyDTO[Category]):
    """DTO for reading Category data."""

    config = SQLAlchemyDTOConfig(exclude={"book_categories", "books"})


class CategoryCreateDTO(SQLAlchemyDTO[Category]):
    """DTO for creating Categorys."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "book_categories", "books"}
    )


class CategoryUpdateDTO(SQLAlchemyDTO[Category]):
    """DTO for updating Categorys with partial data."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "book_categories", "books"},
        partial=True
    )
