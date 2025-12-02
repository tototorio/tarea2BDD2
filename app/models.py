"""Database models for the library management system."""

from dataclasses import dataclass
from datetime import date, datetime

from advanced_alchemy.base import BigIntAuditBase
from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship


class BookCategory(BigIntAuditBase):
    """Intermediate table for the book-category relation"""

    __tablename__ = "book_categories"

    #Foreign keys
    book_id: Mapped[int] = mapped_column(ForeignKey("books.id"), primary_key=True)
    category_id: Mapped[int] = mapped_column(ForeignKey("categories.id"), primary_key=True)

    book: Mapped["Book"] = relationship(back_populates="book_categories")
    category: Mapped["Category"] = relationship(back_populates="book_categories")

class User(BigIntAuditBase):
    """User model with audit fields."""

    __tablename__ = "users"

    username: Mapped[str] = mapped_column(unique=True)
    fullname: Mapped[str]
    password: Mapped[str]

    loans: Mapped[list["Loan"]] = relationship(back_populates="user")
    reviews: Mapped[list["Review"]] = relationship(back_populates="user")

class Review(BigIntAuditBase):
    """Review model"""

    __tablename__ = "reviews"

    rating: Mapped[int]
    comment: Mapped[str]
    review_dt: Mapped[date] = mapped_column(default=datetime.today)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    book_id: Mapped[int] = mapped_column(ForeignKey("books.id"))
    
    user: Mapped["User"] = relationship(back_populates="reviews")
    book: Mapped["Book"] = relationship(back_populates="reviews")


class Book(BigIntAuditBase):
    """Book model with audit fields."""

    __tablename__ = "books"

    title: Mapped[str] = mapped_column(unique=True)
    author: Mapped[str]
    isbn: Mapped[str] = mapped_column(unique=True)
    pages: Mapped[int]
    published_year: Mapped[int]
    stock: Mapped[int] = mapped_column(default=1)
    description: Mapped[str | None]
    language: Mapped[str] = mapped_column(String(2))
    publisher: Mapped[str | None]

    loans: Mapped[list["Loan"]] = relationship(back_populates="book")
    reviews: Mapped[list["Review"]] = relationship(back_populates="book")

    book_categories: Mapped[list["BookCategory"]] = relationship(
        back_populates="book",
        cascade="all, delete-orphan"
    )

    categories: Mapped[list["Category"]] = relationship(
        secondary="book_categories",
        back_populates="books",
        viewonly=True
    )


class Loan(BigIntAuditBase):
    """Loan model with audit fields."""

    __tablename__ = "loans"

    loan_dt: Mapped[date] = mapped_column(default=datetime.today)
    return_dt: Mapped[date | None]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    book_id: Mapped[int] = mapped_column(ForeignKey("books.id"))

    user: Mapped[User] = relationship(back_populates="loans")
    book: Mapped[Book] = relationship(back_populates="loans")

class Category(BigIntAuditBase):
    """Category of book"""

    __tablename__ = "categories"
    name: Mapped[str] = mapped_column(unique=True)
    description: Mapped[str | None]

    book_categories: Mapped[list["BookCategory"]] = relationship(
        back_populates="category",
        cascade="all, delete-orphan"
    )

    books:Mapped[list["Book"]] = relationship(
        secondary="book_categories",
        back_populates="categories",
        viewonly=True
    )

@dataclass
class PasswordUpdate:
    """Password update request."""

    current_password: str
    new_password: str


@dataclass
class BookStats:
    """Book statistics data."""

    total_books: int
    average_pages: float
    oldest_publication_year: int | None
    newest_publication_year: int | None
