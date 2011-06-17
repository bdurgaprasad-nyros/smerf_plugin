require 'test_helper'

class EmpsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emp" do
    assert_difference('Emp.count') do
      post :create, :emp => { }
    end

    assert_redirected_to emp_path(assigns(:emp))
  end

  test "should show emp" do
    get :show, :id => emps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => emps(:one).to_param
    assert_response :success
  end

  test "should update emp" do
    put :update, :id => emps(:one).to_param, :emp => { }
    assert_redirected_to emp_path(assigns(:emp))
  end

  test "should destroy emp" do
    assert_difference('Emp.count', -1) do
      delete :destroy, :id => emps(:one).to_param
    end

    assert_redirected_to emps_path
  end
end
