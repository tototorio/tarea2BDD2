"""Repository for Book database operations."""
from typing import Sequence

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy.orm import Session
from sqlalchemy import select, func, desc

from app.models import Book, Category, Review


class BookRepository(SQLAlchemySyncRepository[Book]):
    """Repository for book database operations."""

    model_type = Book

    def get_avalible_books(self) -> Sequence[Book]:
        stmt = select(Book).where(Book.stock > 0)

        result = self.session.execute(stmt)
        return result.scalars().all()
    
    def find_by_category(self, category_id: int) -> Sequence[Book]:
        stmt = select(Book).join(Book.categories).where(Category.id == category_id)

        result = self.session.execute(stmt)
        return result.scalars().all()

    def get_most_reviewed_books(self, limit: int = 10) -> Sequence[Book]: 
        stmt = (
                select(Book)
                .join(Book.reviews)
                .group_by(Book.id)
                .order_by(desc(func.count(Review.id))
                .limit(limit))
        )

        result = self.session.execute(stmt)
        return result.scalars().all()

    def update_stock(self, book_id: int, quantity: int) -> Book:
        book = self.get(book_id)
        new_stock = book.stock + quantity

        if (new_stock < 0):
            raise ValueError(f"No hay suficiente stock. Stock actual: {book.stock}")

        book.stock = new_stock

        return self.update(book)
    
    def search_by_author(self, author_name: str) -> Sequence[Book]:
        stmt = select(Book).where(Book.author.ilike(f"{author_name}"))

        result = self.session.execute(stmt)
        return result.scalars().all()

async def provide_book_repo(db_session: Session) -> BookRepository:
    """Provide book repository instance with auto-commit."""
    return BookRepository(session=db_session, auto_commit=True)

