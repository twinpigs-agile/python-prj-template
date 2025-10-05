"""
the unit test file name should always start with "test_"!
"""

import unittest

from sample.sample import sample_program


class SampleProgramTestCase(unittest.TestCase):
    def test_sample_program(self):
        self.assertEqual(sample_program(), 0)
