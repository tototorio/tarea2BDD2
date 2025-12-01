"""Repository for Category database operations."""

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy.orm import Session

from app.models import Category


class CategoryRepository(SQLAlchemySyncRepository[Category]):
    """Repository for Category database operations."""

    model_type = Category


async def provide_Category_repo(db_session: Session) -> CategoryRepository:
    """Provide Category repository instance with auto-commit."""
    return CategoryRepository(session=db_session, auto_commit=True)
