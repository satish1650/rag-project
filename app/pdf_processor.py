from pypdf import PdfReader
from pdf2image import convert_from_path
import pytesseract


def extract_text_from_pdf(path):
    reader = PdfReader(path)
    text = ""
    for page in reader.pages:
        text += page.extract_text() or ""
    return text


def extract_images_text(path):
    images = convert_from_path(path)
    text = ""
    for img in images:
        text += pytesseract.image_to_string(img)
    return text


def process_pdf(path):
    text = extract_text_from_pdf(path)
    ocr_text = extract_images_text(path)
    return text + "\n" + ocr_text