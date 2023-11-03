
import optparse
import numpy
import nibabel
import scipy.ndimage


usage = "usage: %prog [options] input output"
parser = optparse.OptionParser(usage=usage)
parser.add_option("-v", "--verbose", dest="verbose",
        action="store_true", default=False, help="Increase verbosity")
parser.add_option("-l", "--low-thresh", dest="lthresh", type="float",
        help="Set low threshold to X", default=0.75)
parser.add_option("-u", "--high-thresh", dest="hthresh", type="float",
        help="Set high threshold to X", default=0.90)
parser.add_option("-s", "--slices", dest="slices", 
	action="store_true", default=False, 
        help="Process slice-at-a-time (2D).")
(options, args) = parser.parse_args()


def hthresh(img, t_high, t_low):
  mask = numpy.zeros(img.shape, dtype="int16")
  mask[img > t_high] = 1
  extent = numpy.zeros(img.shape, dtype="int16")
  extent[img > t_low] = 1
  grew = True
  while grew:
    newmask = numpy.multiply(scipy.ndimage.morphology.binary_dilation(mask), extent)
    grew = numpy.subtract(newmask, mask).sum() > 0
    mask = newmask
  return mask
  
def hthresh2d(img, t_high, t_low):
  result = numpy.zeros(img.shape, dtype="int16")
  for i in range(img.shape[2]):
    islice = img[:,:,i]
    mask = numpy.zeros(islice.shape, dtype="int16")
    mask[islice > t_high] = 1
    extent = numpy.zeros(islice.shape, dtype="int16")
    extent[islice > t_low] = 1
    grew = True
    while grew:
      newmask = numpy.multiply(scipy.ndimage.morphology.binary_dilation(mask), extent)
      grew = numpy.subtract(newmask, mask).sum() > 0
      mask = newmask
    result[:,:,i] = mask
  return result

img = nibabel.load(args[0])
idata = img.get_data()

if options.slices:
  odata = hthresh2d(idata, options.hthresh, options.lthresh)
else:
  odata = hthresh(idata, options.hthresh, options.lthresh)

oimg = nibabel.Nifti1Image(odata, img.get_affine())
nibabel.save(oimg, args[1])
  