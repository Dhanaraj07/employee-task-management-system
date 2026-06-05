from pydantic import BaseModel


class TaskCreate(BaseModel):
    title: str
    description: str
    priority: str
    due_date: str
    status: str
    user_id: int