class SubscriptionsController < MarketplaceController
  #radiant_layout "ffm_specialty_timbers"
  before_filter :require_current_reader
  include ActionView::Helpers::NumberHelper

  def index
    @active_subscription = Subscription.active_subscription_for(current_reader)
  end

  def edit
    @subscription = Subscription.find(:first, :conditions => {:id => params[:id], :reader_id => current_reader.id})
  end

  def new
    @subscription = Subscription.new(params[:subscription])
  end

  def quote_new
    subscription = Subscription.new(params[:subscription])
    levy = CalculatesSubscriptionLevy.levy_for(subscription)
    render :json => {:price => "#{number_to_currency(levy)}", 
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def quote_upgrade
    current_sub = Subscription.active_subscription_for(current_reader)
    new_sub = Subscription.new(params[:subscription])

    normal_price = CalculatesSubscriptionLevy.levy_for(new_sub)
    upgrade_price = CalculatesSubscriptionLevy.
                      upgrade_price(current_sub, new_sub)

    credit = CalculatesSubscriptionLevy.
              credit_if_upgraded(current_sub)

    render :json => {:price => "#{number_to_currency(normal_price)}",
                     :credit => "#{number_to_currency(credit)}",
                     :upgrade_price => "#{number_to_currency(upgrade_price)}",
                     :expires_on => new_sub.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => new_sub.begins_on.strftime('%e %B %Y').strip}

  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = current_reader
    if @subscription.valid?
      levy = CalculatesSubscriptionLevy.levy_for(@subscription)
      @subscription.save!
      @order = Order.create!(:amount => levy,
                            :subscription => @subscription,
                            :reader => current_reader)
      redirect_to make_payment_order_path(@order)
    else
      render :new
    end
  end
end
