class PlaidController < ApplicationController

  def create
    public_token = params[:public_token]
    metadata = params[:metadata]
    account_id = metadata['account_id']

    exchange_token_response = Plaid::User.exchange_token(public_token, account_id)
    access_token = exchange_token_response.access_token
    stripe_bank_token = exchange_token_response.stripe_bank_account_token

    stripe_user = Stripe::Customer.create(description: current_user.full_name, email: current_user.email, source: stripe_bank_token)

    current_user.plaid_id = access_token
    current_user.stripe_account = stripe_user.id
    current_user.account_id = account_id
    current_user.save
    plaid_user = Plaid::User.load(:auth, current_user.plaid_id)
    plaid_user.upgrade(:connect)

    redirect_to root_path
  end
end
