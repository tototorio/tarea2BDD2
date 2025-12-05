"""Controller for Book endpoints."""

from typing import Annotated, Sequence
from dataclasses import dataclass


from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from advanced_alchemy.filters import LimitOffset
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from litestar.params import Parameter

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.book import BookCreateDTO, BookReadDTO, BookUpdateDTO
from app.models import Book, BookStats
from app.repositories.book import BookRepository, provide_book_repo


#Clase auxiliar para recibir actualización de stock
@dataclass
class StockUpdate:
    quantity: int


class BookController(Controller):
    """Controller for book management operations."""

    path = "/books"
    tags = ["books"]
    return_dto = BookReadDTO
    dependencies = {"books_repo": Provide(provide_book_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_books(
        self, 
        books_repo: BookRepository,
        #Filtros opcionales
        book_id: int | None = None,
        book_title: str | None = None,
        category_id: int | None = None,
        author_name: str | None = None,
        year_from: Annotated[int | None, Parameter(query="from")] = None,
        to: int | None = None,
        get_available: bool | None = None,
        get_most_reviewed: bool | None = None,
        get_recent: bool | None = None,
        limit: Annotated[int, Parameter(query="limit", ge=1, le=50, default=10)] = 10,
                         
    ) -> Sequence[Book]:
        """All search related to books"""
        
        if book_id:
            return books_repo.list(id=book_id)
        if book_title:
            return books_repo.list(Book.title.ilike(f"%{book_title}%"))
        if category_id:
            return books_repo.find_by_category(category_id)
        if author_name:
            return books_repo.search_by_author(author_name)
        if year_from is not None and to is not None:
            return books_repo.list(Book.published_year.between(year_from, to))
        if get_available:
            return books_repo.get_available_books()
        if get_most_reviewed:
            return books_repo.get_most_reviewed_books(limit) 
        if get_recent:
            return books_repo.list(
            LimitOffset(offset=0, limit=limit),
            order_by=Book.created_at.desc(),
        ) 

        return books_repo.list()

    @get("/most/reviews")
    async def get_most_reviewed(
        self,
        books_repo: BookRepository,
        limit: Annotated[int, Parameter(query="limit", ge=1, le=50, default=10)] = 10,
    ) -> Sequence[Book]:
        """Get statistics about books."""
        total_books = books_repo.count()
        if total_books == 0:
            return BookStats(
                total_books=0,
                average_pages=0,
                oldest_publication_year=None,
                newest_publication_year=None,
            )
        
    @get("/most/recent")
    @get("/stats")
    async def get_book_stats(
        self,
        books_repo: BookRepository,
    ) -> BookStats:
        """Get statistics about books."""
        total_books = books_repo.count()
        if total_books == 0:
            return BookStats(
                total_books=0,
                average_pages=0,
                oldest_publication_year=None,
                newest_publication_year=None,
            )

        books = books_repo.list()

        average_pages = sum(book.pages for book in books) / total_books
        oldest_year = min(book.published_year for book in books)
        newest_year = max(book.published_year for book in books)

        return BookStats(
            total_books=total_books,
            average_pages=average_pages,
            oldest_publication_year=oldest_year,
            newest_publication_year=newest_year,
        )

    @post("/", dto=BookCreateDTO)
    async def create_book(
        self,
        data: DTOData[Book],
        books_repo: BookRepository,
    ) -> Book:
        """Create a new book."""  
        book_data = data.as_builtins()
        # Validar que el año esté entre 1000 y el año actual
        if not (1000 <= book_data["published_year"] <= 2024):
            raise HTTPException(
                detail="El año de publicación debe estar entre 1000 y 2024",
                status_code=400
            )
        # Validar que el stock sea mayor a 0
        if (book_data["stock"] <= 0):
            raise HTTPException(
                detail="El stock debe ser mayor a 0",
                status_code=400
            )
        
        return books_repo.add(data.create_instance())

    @patch("/{id:int}", dto=BookUpdateDTO)
    async def update_book(
        self,
        id: int,
        data: DTOData[Book],
        books_repo: BookRepository,
    ) -> Book:
        """Update a book by ID."""
        book_data = data.as_builtins()
        #Validar que el stock no sea negativo
        if "stock" in book_data and book_data["stock"] < 0:
            raise HTTPException(
                detail="El stock no puede bajar de 0",
                status_code=400
            )
        
        book, _ = books_repo.get_and_update(match_fields="id", id=id, **data.as_builtins())
        return book
    
    @patch("/stock", dto=None)
    async def update_stock(
        self,
        id: int,
        data: StockUpdate,
        books_repo: BookRepository
    ) -> Book:
        try: 
            return books_repo.update_stock(book_id=id, quantity=data.quantity)
        except ValueError as e:
            raise HTTPException(
                status_code=400,
                details=str(e)
            )

    @delete("/{id:int}")
    async def delete_book(self, id: int, books_repo: BookRepository) -> None:
        """Delete a book by ID."""
        books_repo.delete(id)



""""
    @get("/{id:int}")
    async def get_book(self, id: int, books_repo: BookRepository) -> Book:
        #Get a book by ID.
        return books_repo.get(id)
    
    @get("/search/")
    async def search_book_by_title(
        self,
        title: str,
        books_repo: BookRepository,
    ) -> Sequence[Book]:
        #Search books by title.
        return books_repo.list(Book.title.ilike(f"%{title}%"))

    @get("/filter")
    async def filter_books_by_year(
        self,
        year_from: Annotated[int, Parameter(query="from")],
        to: int,
        books_repo: BookRepository,
    ) -> Sequence[Book]:
        #Filter books by published year.
        return books_repo.list(Book.published_year.between(year_from, to))

    @get("/recent")
    async def get_recent_books(
        self,
        limit: Annotated[int, Parameter(query="limit", default=10, ge=1, le=50)],
        books_repo: BookRepository,
    ) -> Sequence[Book]:
        #Get most recent books.
        return books_repo.list(
            LimitOffset(offset=0, limit=limit),
            order_by=Book.created_at.desc(),
        )
"""