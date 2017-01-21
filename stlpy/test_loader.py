import stl
import unittest


class StlTestHelpers(object):
    def assertComparesIdentical(self, stl1, stl2):
        self.assertEqual(len(stl1.facets), len(stl2.facets))
        print sorted(stl1.vertices)
        print sorted(stl2.vertices)
        for k, v in stl1._vertex_cache.iteritems():
            self.assertTrue(k in stl2._vertex_cache)

class TestLoader(unittest.TestCase):
    def test_cube_loader_ascii(self):
        m = stl.Mesh('files/cube-ascii.stl')
        self.assertEqual(len(m.facets), 12)
        self.assertEqual(len(m._vertex_cache), 8)

    def test_cube_loader_binary(self):
        m = stl.Mesh('files/cube-binary.stl')
        self.assertEqual(len(m.facets), 12)
        self.assertEqual(len(m._vertex_cache), 8)

    def test_loader_ascii(self):
        m = stl.Mesh('files/demo-ascii.stl')
        self.assertEqual(len(m.facets), 1188)


class TestRoundtrips(unittest.TestCase, StlTestHelpers):
    def test_cube_write(self):
        m = stl.Mesh('files/cube-ascii.stl')
        # TODO tempdir, ensure it doesn't exist, etc
        m.write_stl('temp.stl')
        m2 = stl.Mesh('temp.stl')
        self.assertComparesIdentical(m, m2)

    def test_cube_noop_scale(self):
        m1 = stl.Mesh('files/cube-ascii.stl')
        m2 = stl.Mesh('files/cube-ascii.stl')
        m2.scale((0.5,0.5,0.5))
        self.assertRaises(AssertionError, self.assertComparesIdentical, m1, m2)
        m2.scale((2.0, 2.0, 2.0))
        self.assertComparesIdentical(m1, m2)

    def test_cube_noop_stretch(self):
        m1 = stl.Mesh('files/cube-ascii.stl')
        m2 = stl.Mesh('files/cube-ascii.stl')
        m2.stretch('x', 3, 5, 1)
        self.assertComparesIdentical(m1, m2)

class StretchTest(unittest.TestCase, StlTestHelpers):
    def test_cube_stretched_inside(self):
        m1 = stl.Mesh('files/cube-ascii.stl')
        m2 = stl.Mesh('files/cube-ascii.stl')
        m1.scale((1.2, 1.0, 1.0))
        m2.stretch('x', 0.1, 0.9, 0.2)
        self.assertComparesIdentical(m1, m2)
