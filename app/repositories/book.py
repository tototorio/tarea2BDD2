"""Repository for Book database operations."""
from typing import Sequence

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.models import Book


class BookRepository(SQLAlchemySyncRepository[Book]):
    """Repository for book database operations."""

    model_type = Book

    def get_avalibre_books(self) -> Sequence[Book]:
        stmt = select(Book).where(Book.stock > 0)

        result = self.session.execute(stmt)

        return result.scalars().all()


async def provide_book_repo(db_session: Session) -> BookRepository:
    """Provide book repository instance with auto-commit."""
    return BookRepository(session=db_session, auto_commit=True)

