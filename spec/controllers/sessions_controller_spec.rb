require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home page for authenticated users" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      it "redirects to home page" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password
        expect(response).to redirect_to home_path
      end
      it "sets the user into the session" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password
        expect(session[:user_id]).to eq(bob.id)
      end
      it "sets flash notice message" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid credentials" do
      it "does not set the user into the session" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password + "123abc"
        expect(session[:user_id]).to be_nil
      end
      it "redirects to the sign in page" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password + "123abc"
        expect(response).to redirect_to sign_in_path
      end
      it "sets the flash danger message" do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password + "123abc"
        expect(flash[:danger]).to_not be_blank
      end
    end
  end

  describe "DELETE destroy" do
    it "it redirects to home path" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      delete :destroy
      expect(response).to redirect_to root_path
    end
    it "clears the user from the session" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
    it "sets flash notice message" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      delete :destroy
      expect(flash[:notice]).to be_present
    end
  end
end
