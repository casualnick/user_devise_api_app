class Api::V1::BooksController < ApplicationController
    before_action :set_book, only: [:show]

    def index
        @books = Book.all.includes(:reviews)
        books_serializer = parse_json(@books)
        json_response("Succesful books index request", true, {books: books_serializer}, :ok)
    end

    def show
        book_serializer = parse_json(@book)
        json_response("Succesful books show request", true, {books: book_serializer}, :ok)
    end


    private

    def set_book
        @book = Book.find(params[:id])
        unless @book.present?
            json_response("Couldn't find book", false, {}, :not_found)
        end
    end
end