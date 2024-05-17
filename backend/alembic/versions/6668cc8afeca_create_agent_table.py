"""create_agent_table

Revision ID: 6668cc8afeca
Revises: 
Create Date: 2024-04-22 15:10:57.595552

"""
from typing import Sequence, Union
from sqlalchemy.dialects.postgresql import UUID

from alembic import op
import sqlalchemy as sa

from app.models.robot_chat.agent import table_name_robot_agent
from app.models.base import BaseModel

# revision identifiers, used by Alembic.
revision: str = '6668cc8afeca'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        table_name_robot_agent,
        sa.Column('id', sa.BigInteger(), nullable=False),
        sa.Column('uuid', UUID(as_uuid=True), default=BaseModel.uuid.default.arg, unique=True),

        sa.Column('customer_id', sa.String(length=255), nullable=True),
        sa.Column('name', sa.String(), nullable=True),
        sa.Column('description', sa.String(), nullable=True),
        sa.Column('persona_prompt', sa.Text(), nullable=True),
        sa.Column('status', sa.SmallInteger(), nullable=True),
        sa.Column('avatar_url', sa.String(), nullable=True),

        sa.Column('created_at', sa.TIMESTAMP(timezone=True), default=BaseModel.created_at.default.arg, nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(timezone=True), default=BaseModel.updated_at.default.arg,
                  onupdate=BaseModel.updated_at.default.arg, nullable=False),
        sa.Column('is_deleted', sa.Boolean(), default=BaseModel.is_deleted.default.arg),
        sa.PrimaryKeyConstraint('id')
    )


def downgrade() -> None:
    op.drop_table(table_name_robot_agent)

