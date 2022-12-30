import cv2
import numpy as np
import pytesseract
import math
import re
from nltk.metrics.distance import edit_distance
import openfoodfacts
import sqlite3

# get grayscale image
def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# noise removal
def remove_noise(image):
    return cv2.medianBlur(image,5)
 
#thresholding
def thresholding(image):
    return cv2.threshold(image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

#dilation
def dilate(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.dilate(image, kernel, iterations = 1)
    
#erosion
def erode(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.erode(image, kernel, iterations = 1)

#opening - erosion followed by dilation
def opening(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

#canny edge detection
def canny(image):
    return cv2.Canny(image, 100, 200)

#skew correction
def deskew(image):
    coords = np.column_stack(np.where(image > 0))
    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
    return rotated

#template matching
def match_template(image, template):
    return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED) 

def capture_image():   
    cap = cv2.VideoCapture(0)

    while(True):
        ret, frame = cap.read()
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2BGRA)

        cv2.imshow('frame', rgb)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            out = cv2.imwrite('capture.jpg', frame)
            break

    cap.release()
    cv2.destroyAllWindows()
    img = cv2.imread('capture.jpg')
    gray = get_grayscale(img)
    thresh = thresholding(gray)
    opening = opening(gray)
    canny = canny(gray)
    h, w, c = img.shape
    return canny

def process_image(image_name, db):
    print("RAW:")
    ingredients_raw = pytesseract.image_to_string(image_name)
    print(ingredients_raw)
    ingredients = re.split(r"[,:]+", ingredients_raw)
    ingredients = [spell_fix(elt.upper().replace('\n', ' ').strip(), db) for elt in ingredients
                   if len(elt) > 0 and elt.lower() != 'ingredients']
    print("PROCESSED:")
    print(ingredients)
    return ingredients

def spell_fix(word, db):
    try:
        if db[word]:
            return word
    except KeyError:
        pass

    smallest_chem = ''
    smallest_ed = math.inf
    for chem in db.keys():
        curr_ed = edit_distance(word, chem)
        if curr_ed < smallest_ed:
            smallest_chem = chem
            smallest_ed = curr_ed
    return smallest_chem

def main():
    img = capture_image()
    ingredients = openfoodfacts.facets.get_ingredients()
    print(type(ingredients))
    OCRlist = process_image(img, ingredients)
    print(OCRlist)


if __name__ == "__main__":
    main()