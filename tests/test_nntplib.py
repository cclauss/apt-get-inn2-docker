#!/usr/bin/env python3

"""
Test interacting with the local INN server using the Python <= 3.12 nntplib module.
"""

import pathlib

def test_always_pass():
    """Allow pytest to find at least one passing pytest on Python >= 3.13."""

try:
    import nntplib  # Removed from the Standard Library in Python 3.13.
except ImportError:
    import sys

    sys.exit()

def test_nntplib(hostname: str = "localhost"):
    with nntplib.NNTP(hostname, readermode=True) as nntp_server:
        print(f"{nntp_server = }")
        # print(f"{nntp_server.starttls() = }")  # nntplib.NNTPTemporaryError: 401 MODE-READER
        print(f"{nntp_server.nntp_version = }")
        print(f"{nntp_server.nntp_implementation = }")
        print(f"{nntp_server.getwelcome() = }")
        print(f"{nntp_server.getcapabilities() = }")
        print(f"{nntp_server.list() = }")
        print("---")
        print("News group list:")
        print(
            "\n".join(
                f"{i}. {group_info.group}"
                for i, group_info in enumerate(nntp_server.list()[1], 1)
            )
        )
        print("---")
        # Ensure the 'local.test' group has no articles.
        resp, count, first, last, name = nntp_server.group("local.test")
        print(f"Group '{name}' has {count} articles, range {first} to {last}.")
        # Post an article to the 'local.test' group.
        msg = (pathlib.Path(__file__).parent / "inn_article_001.txt").read_text()
        # print(f"{msg = }")
        response = nntp_server.post(msg.encode("utf-8"))
        print(f"{response = }")
        # Verify that the article is there.
        resp, count, first, last, name = nntp_server.group("local.test")
        print(f"Group '{name}' has {count} articles, range {first} to {last}.")
        # Read the article.
        stat = nntp_server.stat()  # last() and next() both fail
        # print(f"{stat = }")
        article = nntp_server.article(stat[2])
        print(f"{article = }\n---")
        # Print the lines of the article
        print("\n".join(line.decode("utf-8") for line in article[1].lines))
        print("---")
        # Print the overview information
        resp, count, first, last, name = nntp_server.group("local.test")
        # print(resp, count, first, last, name)
        resp, overviews = nntp_server.over((first, last))
        for id, over in overviews:
            print(id, nntplib.decode_header(over["subject"]))
