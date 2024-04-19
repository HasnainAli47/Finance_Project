# class PdfExamplesController < ApplicationController
#   def generate_pdf
#     pdf_content = WickedPdf.new.pdf_from_string("<h1>Hello, this is a PDF!</h1>")
#     send_data pdf_content, filename: "example.pdf", disposition: "attachment"
#   end
# end
