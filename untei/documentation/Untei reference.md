# Article
After a markdown document is parsed, an `article` class object is created. This object holds several fields and methods convenient to create the top page and tag pages. You can access to an article object through several methods provided for `tag.py` and `index.py`. Detailed information on how to get an article object is available at chapters for Tag and Index.

Even if you edit an article object, neither the original markdown file nor the generated HTML file are updated.

## article.title
- Type : `str`

Its value is the title of the article. You can define this value by writing `title = ....` on the top of the markdown file. If you do not specify the value, then its file name will be used instead.

## article.tags
- Type : `list` of `str` objects

It stores all tag names on the article. You can define this value by writing `tags = tag1, tag2, ....` on the top of the markdown file.

If you do not specify any tag, then the article is not tagged, and the value will be an empty list.

## article.date
- Type : `datetime.date`

Its value is the published date of the article. You can specify this value by writing like `date = 2018-01-01` in the format of `YYYY-MM-DD`. If you do not specify the value, then it will be the last modified date of the markdown file.

## article.content
- Type : `str`

It is an HTML text generated by parsing the markdown file.

## article.authors
- Type : `list` of `str` objects

Its value is the author of the article. You can specify this value by writing `author = author1, author2, ...` on the top of the markdown file. If you do not specify the value, then an empty list is stored at this field.

## article.path
- Type : `str`

The local path to the generated HTML file is assigned to the field.

## article.status
- Type : `str`

The status of the article, which is defined with `status = ready/draft` on the top of the markdown file, is assigned to this field. But, currently if only `ready` stated articles will be passed to `index.py` and `tag.py`, which means if you get this value, then it is always `ready`.


# Tag
`tag.py` is called at the time of creating a page for a tag. One common use of such tag pages is to list articles tagged on the way. After `tag.py` is called, the last value of a str object `body` is used as the content of the tag page.

## body
- Type : `str`

The variable is used to hand a configured content to Untei. If you fail to set the value then the content will be an empty string.

## tag
- Type : `str`

This variable stores the name of the tag.

## latest_tagged_articles(num_of_articles)
- Type : method receiving `int` and returning `list` of `article` objects

This method returns the list of articles tagged as the tag. The argument `int` indicates the number of articles you want.

The returned articles are already sorted by date - the earlier the article's date is, the smaller the index of the article on the list - .

# index
`index.py` is called at the time of creating `index.html`, which is used as the top page. After `index.py` is called, the last value of a str object `body` is used as the content of the tag page.

## body
- Type : `str`

The variable is used to hand a configured content to Untei. If you fail to set the value then the content will be an empty string.

## all_tags
- Type : `list` of `str` objects

This list stores all tags used on your website. Tags are defined at each page and integrated into this value.

## latest_articles(num_of_articles)
- Type : method receiving `int` and returning `list` of `article` objects

This method returns the list of articles on your website. The argument `int` indicates the number of articles you want.

The returned articles are already sorted by date just as `latest_tagged_articles` method for `tag.py`.

## latest_articles_tagged_as(num_of_articles, tag)
- Type : method receiving `int` and returning `list` of `article` objects

This method returns the list of articles tagged as the `tag`. The argument `int` indicates the number of articles you want.

The returned articles are already sorted by date.
