require 'test_helper'

class GameRatingsControllerTest < ActionController::TestCase
  setup do
    @game_rating = game_ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_rating" do
    assert_difference('GameRating.count') do
      post :create, :game_rating => @game_rating.attributes
    end

    assert_redirected_to game_rating_path(assigns(:game_rating))
  end

  test "should show game_rating" do
    get :show, :id => @game_rating.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @game_rating.to_param
    assert_response :success
  end

  test "should update game_rating" do
    put :update, :id => @game_rating.to_param, :game_rating => @game_rating.attributes
    assert_redirected_to game_rating_path(assigns(:game_rating))
  end

  test "should destroy game_rating" do
    assert_difference('GameRating.count', -1) do
      delete :destroy, :id => @game_rating.to_param
    end

    assert_redirected_to game_ratings_path
  end
end
