import hashlib


def get_file_checksum(file: str) -> str:
    return hashlib.md5(open(file, 'rb').read()).hexdigest()
