import requests
import toml
import frontmatter
import os

API_KEY =  os.environ.get("B10G_APIKEY")
SITE_ID = os.environ.get("B10G_SITE_ID")

print API_KEY, SITE_ID


OLD_POSTS = os.environ.get(
    "JAMIE_POSTS",
    "/Users/jcurle/git/curle/migrateposts"
)

# iterate over all the posts
for post_name in os.listdir(OLD_POSTS):
    print "processing: {}".format(post_name)

    # skip cruft
    if post_name in ['.DS_Store', '.git']:
        print "skipping cruft: {}".format(post_name)
        continuegit

    with open(os.path.join(OLD_POSTS, post_name), 'r') as post_fp:
        # read the post
        post = frontmatter.load(post_fp)

        # make the slug
        slug = post_name.replace(".md", "")

        # now build the post data
        post_data = {
            "title": post['title'],
            "markdown": post.content,
            "slug": slug,
            "status": "PUBLISHED" if post.get("draft") == False else "DRAFT",
            "site_id": SITE_ID,
            "inserted_at": post["date"]
        }

        # make the headers
        headers = {
            "Authorization": "Bearer {}".format(API_KEY)
        }


        # make the request
        r = requests.post(
            "https://dev-jamie.curle.io/api/posts/create",
            post_data,
            headers=headers,
            verify=False)