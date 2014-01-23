require 'spec_helper'

#Note of incompleteness:
# this is close to the original generated code and tests more crud than the actual basket functionality
# it should test item adding and the like, but hmm how do they say: "not now", or was it "not yet"

describe BasketsController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BasketsController. Be sure to keep this updated.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all baskets as @baskets" do
      count_before = Basket.count
      basket = create :basket
      get :index, {}, valid_session
      assigns(:basket_scope).count.should be count_before + 1
    end
  end

  describe "GET show" do
    it "assigns the requested basket as @basket" do
      basket = create :basket
      get :show, {:id => basket.to_param}, valid_session
      assigns(:basket).should eq(basket)
    end
  end

  describe "GET new" do
    it "assigns a new basket as @basket" do
      get :new, {}, valid_session
      assigns(:basket).should be_a(Basket)
    end
  end

  describe "GET edit" do
    it "assigns the requested basket as @basket" do
      basket = create :basket
      get :edit, {:id => basket.to_param}, valid_session
      assigns(:basket).should eq(basket)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Basket" do
        expect {
          post :create, {:basket => attributes_for(:basket)}, valid_session
        }.to change(Basket, :count).by(1)
      end

      it "assigns a newly created basket as @basket" do
        post :create, {:basket => attributes_for(:basket)}, valid_session
        assigns(:basket).should be_a(Basket)
        assigns(:basket).should be_persisted
      end

      it "redirects to the created basket" do
        post :create, {:basket => attributes_for(:basket)}, valid_session
        response.should redirect_to(Basket.first)
      end
    end

  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested basket as @basket" do
        basket = create :basket
        put :update, {:id => basket.to_param, :basket => attributes_for(:basket)}, valid_session
        assigns(:basket).should eq(basket)
      end

      it "redirects to the basket" do
        basket = create :basket
        put :update, {:id => basket.to_param, :basket => attributes_for(:basket)}, valid_session
        response.should redirect_to(basket)
      end
    end

    describe "with invalid params" do
      it "assigns the basket as @basket" do
        basket = create :basket
        # Trigger the behavior that occurs when invalid params are submitted
        Basket.any_instance.stub(:save).and_return(false)
        put :update, {:id => basket.to_param, :basket => { :some => :thing_to_stop_erros  }}, valid_session
        assigns(:basket).should eq(basket)
      end

    end
  end

  describe "DELETE destroy" do
    it "destroys the requested basket" do
      basket = create :basket
      expect {
        delete :destroy, {:id => basket.to_param}, valid_session
      }.to change(Basket, :count).by(-1)
    end

    it "redirects to the baskets list" do
      basket = create :basket
      delete :destroy, {:id => basket.to_param}, valid_session
      response.should redirect_to(baskets_url)
    end
  end

end
