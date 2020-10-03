class Api::V1::ReviewsController < ApplicationController
    before_action :set_book
    before_action :set_review, only: [:show, :update, :destroy]
    before_action :authenticate_with_token!, only: :create

    def index
        @reviews = @book.reviews
        reviews_serializer = parse_json(@reviews)
        json_response("Succesful reviews index request", true, {reviews: reviews_serializer}, :ok)
    end

    def show
        review_serializer = parse_json(@review)
        json_response("Succesful reviews show request", true, {reviews: review_serializer}, :ok)
    end

    def create
        review = Review.new(review_params)
        review.user_id = current_user.id
        review.book_id = params[:book_id]
        if review.save
            review_serializer = parse_json(@review)
           json_response("Succesful reviews create request", true, { reviews: review_serializer }, :created)
        else
            json_response("There have been problem with creating review", false, { }, :unprocessable_entity)
        end
    end

    def update
        if correct_user(@review.user)
            if @review.update(review_params)
                review_serializer = parse_json(@review)
                json_response("Succesful reviews update request", true, {reviews: review_serializer}, :ok)
            else
                json_response("There have been problem with update Review", false, { }, :unprocessable_entity)
            end
        else
            json_response("You have not permission to do this", false, { }, :unauthorized)
        end
    end

    def destroy
        if correct_user(@review.user)
            if @review.destroy!
                json_response("Succesful reviews delete request", true, {}, :ok)
            else
                json_response("There have been problem with delete Review", false, { }, :unprocessable_entity)
            end
        else
            json_response("You have not permission to do this", false, { }, :unauthorized)
        end
    end

    private
    
    def set_book
        @book = Book.find(params[:book_id])
        unless @book.present?
            json_response("Couldn't find book", false, {}, :not_found)
        end
    end

    def set_review
        @review = Review.find(params[:id])
        unless @review
            json_response("Couldn't find Review", false, {}, :not_found)
        end
    end

    def review_params
        params.require(:review).permit(:title, :content_rating, :recomment_rating, :image_review)
    end
end