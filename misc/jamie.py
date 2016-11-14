import requests
import toml
import os

API_KEY =  os.environ.get("B10G_APIKEY")
SITE_ID = os.environ.get("B10G_SITE_ID")

print API_KEY, SITE_ID


OLD_POSTS = os.environ.get(
    "JAMIE_POSTS",
    "/Users/jcurle/git/curle/jamiecurle/content/posts"
)

# iterate over all the posts
for post_name in os.listdir(OLD_POSTS):
    print "processing: {}".format(post_name)

    # skip cruft
    if post_name in ['.DS_Store']:
        print "skipping cruft: {}".format(post_name)
        continue

    with open(os.path.join(OLD_POSTS, post_name), 'r') as post_fp:
        # read the post
        post = post_fp.read()

        # make the slug
        slug = post_name.replace(".md", "")

        # make the parts
        parts = post.split('---\n')

        # make the post meta
        meta = toml.loads(parts[1])


        # and the post content
        body = parts[2]

        # now build the post data
        post_data = {
            "title": meta['title'],
            "body": body,
            "slug": slug,
            "status": "PUBLISHED" if meta.get("draft") == False else "DRAFT",
            "site_id": SITE_ID,
            "inserted_at": meta["date"]
        }

        # make the headers
        headers = {
            "Authorization": "Bearer {}".format(API_KEY)
        }

        # make the request
        r = requests.post(
            "https://dev-jamie.curle.io/api/posts/create",
            {"post": post_data},
            headers=headers,
            verify=False)

        print r.status_code
        print r.content
        print headers,post_data

