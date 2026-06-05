from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from database import engine, Base

from models.user import User
from models.task import Task

from routers.auth import router as auth_router
from routers.tasks import router as task_router

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
Base.metadata.create_all(bind=engine)

app.include_router(auth_router)
app.include_router(task_router)

@app.get("/")
def root():
    return {"message": "Employee Task Management API Running"}