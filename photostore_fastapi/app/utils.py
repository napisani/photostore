import hashlib


def get_file_checksum(file: str) -> str:
    return hashlib.md5(open(file, 'rb').read()).hexdigest()


def get_file_extension(filename: str) -> str:
    s = filename.rsplit('.', 1)
    if len(s) < 2:
        return None
    return s[1].lower()
