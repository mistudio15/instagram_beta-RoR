require "test_helper"
require "faker"

class IntegrationTest < ActionDispatch::IntegrationTest


  test 'unauthorized user will be redirected to login page' do
    # let users
    get users_path
    assert_redirected_to signin_path
  end

  test 'user with incorrect credentials will be redirected to login page' do
    # log in
    post sessions_path, params: { email: Faker::Internet.email, password: Faker::Lorem.word }
    assert_redirected_to '/signin'
  end

  test "user with correct credentials can see other users, their posts, write comments" do 
    # create credentials for user_1
    email_1 = Faker::Internet.email
    pass_1 = Faker::Lorem.word
    username_1 = Faker::Lorem.word

    # sign up 1
    user_1 = User.create(username: username_1, email: email_1, password: pass_1)
    post_1 = user_1.posts.build(title: 'title')
    post_1.photo.attach(io: File.open("#{Rails.root}/public/DSC01116_1.jpg"), filename: 'DSC01116_1.jpg', content_type: 'image/png')

    assert post_1.save

    # create credentials for user_2
    email_2 = Faker::Internet.email
    pass_2 = Faker::Lorem.word
    username_2 = Faker::Lorem.word

    # sign up 2
    post users_url, params: { user: { username: username_2, email: email_2, password: pass_2 } }
    assert_response :redirect

    # log in
    post sessions_path, params: { email: email_2, password: pass_2 }
    assert_response :redirect

    # look users
    get users_path
    assert_response :success

    # look all posts of user_1
    get user_path(user_1)
    assert_response :success

    # look post_1 of user_1
    get user_post_path(user_1, post_1)
    assert_response :success

    # try to edit user
    get edit_user_path(user_1)
    assert_equal @response.body.to_s, "Access denied"

    # try to edit post
    get edit_user_post_path(user_1, post_1)
    assert_equal @response.body.to_s, "Access denied"

    # write comment
    post user_post_comments_path user_1, post_1, params: { comment: { body: 'great photo' } }
    assert_response :redirect

    # try to delete comment
    delete user_post_comment_path(user_1, post_1, post_1.comments[0])
    assert_response :redirect

    # try to create another user's post
    get new_user_post_path(user_1)
    assert_equal @response.body.to_s, "Access denied"

    # like
    get "/users/#{user_1.id}/posts/#{post_1.id}/likes.json"
    assert_response :success
    assert @response.body.include?('red')
  end 
end
