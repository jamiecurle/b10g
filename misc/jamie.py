import requests
import frontmatter
import os

requests.packages.urllib3.disable_warnings()

API_KEY =  os.environ.get("B10G_API_KEY")
SITE_ID = os.environ.get("B10G_SITE_ID")



OLD_POSTS = os.environ.get(
    "JAMIE_POSTS",
    "/Users/jcurle/git/curle/migrateposts"
)

# iterate over all the posts
for post_name in os.listdir(OLD_POSTS):
    print("processing: {}".format(post_name))

    # skip cruft
    if post_name in ['.DS_Store', '.git']:
        print("skipping cruft: {}".format(post_name))
        continue

    post_file = os.path.join(OLD_POSTS, post_name)

    # load the frontmatter
    post = frontmatter.load(post_file)

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
        "https://curle-b10g.herokuapp.com/api/posts/create",
        post_data,
        headers=headers,
        verify=False)

    if r.status_code == 400 and 'site_slug_id' in r.json()['errors']:
        print(r.json())
