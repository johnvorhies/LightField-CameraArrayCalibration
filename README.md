# LightField-CameraArrayCalibration
Tools for calibrating a high-density array of cameras for light field imaging. Some of this code is an adaptation of [Ashley Stewart's Planar-LF-Calibration](https://github.com/astewartau/Planar-LF-Calibration).

## Usage
A calibration pipeline using these functions should follow this:

**createTransformMatrixLF_Center/Checkerboard**->**rectifyImagesViaTransforms**->**cropRectified**->**image2stuv**
->**analyzeEPI**

## Functions

### analyzeEPI(st_uv)
Creates visuals of an EPI from the central light field sub-image and its frequency content. Can be used to validate the homography matrices applied to the light field sub-images. Choosing the V coordinate is important to get an EPI with enough depth content. Feature detection could be applied to find appropriate rows of pixels that display depth content.

#### Inputs:
* st_uv: A 4-D grayscale or 5-D RGB light field in two-plane parameterization form.

### tforms = createTransformMatrixLF_Center(originalDir)
Finds the homography matrices for each light field sub-image such that they are warped to the perspective of the central light field sub-image. Uses SURF features to match points. Results vary based on the geometry of the objects in the scene.

#### Inputs:
* originalDir: directory of light field sub-images, numerically ordered such that the lowest number is the bottom left light field sub-image and a zig-zag naming pattern is followed.

#### Outputs:
* tforms: The homography matrices as a projective2d object

### tforms = createTransformMatrixLF_Checkerboard(checkerboardDir)
Finds the homography matrices for each light field sub-image such that they are warped to the perspective of the central light field sub-image. Uses a checkerboard as a reference plane for calibration. This results in a better calibration than using SURF features, but requires calibrating the light field to a specific reference plane. 

#### Inputs:
* checkerboardDir: directory of light field sub-images, numerically ordered such that the lowest number is the bottom left light field sub-image and a zig-zag naming pattern is followed. The light field should be an image of a rectangular checkerboard where one side has an even number of squares and the other is odd.

#### Outputs:
* tforms: The homography matrices as a projective2d object

### cropRectified(rectifiedDir, croppedDir)
Crops the rectified images to a desired size, using the central light field sub-image as a reference.

#### Inputs:
* rectifiedDir: directory of rectified light field sub-images, numerically ordered such that the lowest number is the bottom left light field sub-image and a zig-zag naming pattern is followed.
* croppedDir: directory to write cropped and rectified light field sub-images.

### [st_uv,st_uv_rgb] = image2stuv(imageDir)
Utility function to create 4-D grayscale and 5-D RGB light fields in the two-plane parameterization form from a directory of images.

#### Inputs:
* imageDir: Directory of light field sub-images, numerically ordered such that the lowest number is the bottom left light field sub-image and a zig-zag naming pattern is followed.

#### Outputs:
* st_uv: 4-D grayscale light field in two-plane parameterization form
* st_uv_rgb: 5-D RGB light field in two-plane parameterization form

### rectifyImagesViaTransforms(tforms, originalDir, rectifiedDir)
Applies homography matrices found in **createTransformMatrixLF_Center** or **createTransformMatrixLF_Checkerboard** to a set of light field sub-images.

#### Inputs:
* tforms: A projective2d object of homography matrices
* originalDir: Directory of light field sub-images, numerically ordered such that the lowest number is the bottom left light field sub-image and a zig-zag naming pattern is followed.
* rectifiedDir: directory to write rectified light field sub-images.
