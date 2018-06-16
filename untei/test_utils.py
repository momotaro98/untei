import unittest
from utils import safe_apply_template


class TestUtils(unittest.TestCase):
    def test_safe_apply_template_unsafe_case1(self):
        template = \
            """
            <h1>page title</h1>
            <p>your body</p>
            <<footer>>
            """

        assignment_dict = {
            "title": "TEST TITLE",
            "body": "TEST title BODY", # not safe
            "footer": "End!"
        }

        expected = \
            """
            <h1>page TEST TITLE</h1>
            <p>your TEST title BODY</p>
            <<End!>>
            """

        actual = safe_apply_template(template, assignment_dict)
        self.assertEqual(expected, actual)

    def test_safe_apply_template_unsafe_case2(self):
        template = \
            """
            <h1>page title</h1>
            <p>your body</p>
            <<footer>>
            """

        assignment_dict = {
            "title": "TEST body TITLE", # not safe
            "body": "TEST BODY",
            "footer": "End!"
        }

        expected = \
            """
            <h1>page TEST body TITLE</h1>
            <p>your TEST BODY</p>
            <<End!>>
            """

        actual = safe_apply_template(template, assignment_dict)
        self.assertEqual(expected, actual)

    def test_safe_apply_template_safe_case1(self):
        template = \
            """
            <h1>page title</h1>
            <p>your body</p>
            <<footer>>
            """

        assignment_dict = {
            "title": "TEST TITLE SAFE",
            "body": "TEST BODY SAFE",
            "footer": "End!"
        }

        expected = \
            """
            <h1>page TEST TITLE SAFE</h1>
            <p>your TEST BODY SAFE</p>
            <<End!>>
            """

        actual = safe_apply_template(template, assignment_dict)
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
