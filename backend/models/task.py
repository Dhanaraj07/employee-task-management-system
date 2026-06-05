from sqlalchemy import Column, Integer, String, ForeignKey
from database import Base

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    description = Column(String(500))
    priority = Column(String(20))
    due_date = Column(String(50))
    status = Column(String(50))

    user_id = Column(Integer, ForeignKey("users.id"))