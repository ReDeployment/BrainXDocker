"""add message model

Revision ID: 000000000016
Revises: 000000000020
Create Date: 2024-07-07 00:27:18.478591

"""
import datetime
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy import UUID

from app.models.base import table_name_message, table_name_conversation

# revision identifiers, used by Alembic.
revision: str = '000000000016'
down_revision: Union[str, None] = '000000000015'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None



def upgrade() -> None:
    # 检查表是否存在
    op.create_table(
        table_name_message,
        sa.Column('id', sa.BigInteger(), nullable=False),
        sa.Column('uuid', UUID(as_uuid=True), nullable=False, index=True, unique=True),

        sa.Column('conversation_uuid', UUID(as_uuid=True), nullable=False),
        sa.Column('reply_to_message_uuid', UUID(as_uuid=True), nullable=True),
        sa.Column('content', sa.Text(), nullable=True),
        sa.Column('role', sa.SmallInteger(), nullable=True),
        sa.Column('type', sa.SmallInteger(), nullable=True),

        sa.Column('created_at', sa.TIMESTAMP(timezone=True), default=datetime.UTC, nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(timezone=True), default=datetime.UTC, nullable=False),
        sa.Column('deleted_at', sa.TIMESTAMP(timezone=True), default=None, nullable=True),
        sa.PrimaryKeyConstraint('id'),

        # 添加索引
        sa.Index('idx_message_conversation_uuid', 'conversation_uuid'),
        sa.Index('idx_message_reply_to_message_uuid', 'reply_to_message_uuid'),

    )


def downgrade() -> None:
    op.drop_table(table_name_message)
