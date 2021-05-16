require 'rails_helper'
require 'spec_helper'

RSpec.describe ApplicationController, type: :controller, legacy: true do
  controller do
    def test_exception_handling
      raise Timeout::Error
    end

    def test_auth
      render json: { message: 'authenticated successfully' }, status: :ok
    end
  end

  describe 'basic authentication' do
    before do
      routes.draw do
        post 'test_auth' => 'anonymous#test_auth'
      end
    end

    context 'without credentials/auth header' do
      it 'should skip the auth also do not set current user' do
        post :test_auth
        expect(assigns(:current_user)).to eq(nil)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'invalid credentials' do
      it 'should return unauthorized' do
        invalid_header = {
          'ACCEPT' => 'application/json',
          'Authorization' => 'some-invalid-key'
        }
        request.headers.merge!(invalid_header)
        post :test_auth
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'valid credentials' do
      before { create_normal_user }

      it 'should be authorized and sets the current user' do
        request.headers.merge!(@user_headers)
        post :test_auth
        expect(assigns(:current_user)).to eq(@user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'exception handling' do
    before do
      routes.draw do
        post 'test_exception_handling' => 'anonymous#test_exception_handling'
      end
    end

    context 'unknown error happens' do
      it 'handles the exception' do
        post :test_exception_handling
        expect(response).to have_http_status(500)
        expect(JSON.parse(response.body)['errors']).to eq(['Oops! Something went wrong.'])
      end
    end
  end
end
