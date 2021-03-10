"""init

Revision ID: e79cb49f47ef
Revises: d4867f3a4c0a
Create Date: 2021-03-03 20:58:17.553212

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'e79cb49f47ef'
down_revision = 'd4867f3a4c0a'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('photo',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('path', sa.String(length=1024), nullable=False),
    sa.Column('filename', sa.String(length=256), nullable=False),
    sa.Column('checksum', sa.String(length=256), nullable=False),
    sa.Column('gphoto_id', sa.String(length=256), nullable=False),
    sa.Column('mime_type', sa.String(length=50), nullable=False),
    sa.Column('media_metadata', sa.JSON(none_as_null=True), nullable=True),
    sa.Column('thumbnail_path', sa.String(length=1024), nullable=False),
    sa.Column('creation_date', sa.DateTime(), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_photo_id'), 'photo', ['id'], unique=False)
    op.drop_index('ix_item_description', table_name='item')
    op.drop_index('ix_item_id', table_name='item')
    op.drop_index('ix_item_title', table_name='item')
    op.drop_table('item')
    op.drop_index('ix_user_email', table_name='user')
    op.drop_index('ix_user_full_name', table_name='user')
    op.drop_index('ix_user_id', table_name='user')
    op.drop_table('user')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('user',
    sa.Column('id', sa.INTEGER(), server_default=sa.text("nextval('user_id_seq'::regclass)"), autoincrement=True, nullable=False),
    sa.Column('full_name', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('email', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('hashed_password', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('is_active', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.Column('is_superuser', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.PrimaryKeyConstraint('id', name='user_pkey'),
    postgresql_ignore_search_path=False
    )
    op.create_index('ix_user_id', 'user', ['id'], unique=False)
    op.create_index('ix_user_full_name', 'user', ['full_name'], unique=False)
    op.create_index('ix_user_email', 'user', ['email'], unique=True)
    op.create_table('item',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('title', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('description', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('owner_id', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['owner_id'], ['user.id'], name='item_owner_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='item_pkey')
    )
    op.create_index('ix_item_title', 'item', ['title'], unique=False)
    op.create_index('ix_item_id', 'item', ['id'], unique=False)
    op.create_index('ix_item_description', 'item', ['description'], unique=False)
    op.drop_index(op.f('ix_photo_id'), table_name='photo')
    op.drop_table('photo')
    # ### end Alembic commands ###