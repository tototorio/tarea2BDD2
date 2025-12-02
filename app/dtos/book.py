"""Data Transfer Objects for Book endpoints."""

from advanced_alchemy.extensions.litestar import SQLAlchemyDTO, SQLAlchemyDTOConfig

from app.models import Book


class BookReadDTO(SQLAlchemyDTO[Book]):
    """DTO for reading book data."""

    config = SQLAlchemyDTOConfig(exclude={"password", "book_categories", "reviews", "loans"}, max_nested_depth=1)


class BookCreateDTO(SQLAlchemyDTO[Book]):
    """DTO for creating books."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "loans", "reviews", "categories", "book_categories"},
    )


class BookUpdateDTO(SQLAlchemyDTO[Book]):
    """DTO for updating books with partial data."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "loans"},
        partial=True,
    )
