class Admin::ReadersPlusController < AdminController
  def index
    if params[:page].blank?
      params[:page] = 1
    end
    if token = params[:query]
      search_cols = %w[forename surname email nzffa_membership_id id]
      query_bits = []
      token_bits = []
      search_cols.each do |col|
        query_bits << "#{col} LIKE ?"
        token_bits << "%#{token}%"
      end
      @readers = Reader.paginate(:page => params[:page], :conditions => [query_bits.join(' OR '), *token_bits])
    else
      @readers = Reader.paginate(:page => params[:page])
    end
  end

  def edit
    @reader = Reader.find params[:id]
  end

  def show
    @reader = Reader.find params[:id]
    @current_subscription = Subscription.current_subscription_for(@reader)
  end

  def update
    @reader = Reader.find params[:id]
    @reader.attributes = params[:reader]
    if @reader.save(false)
      flash[:notice] = 'Updated reader'
      redirect_to [:admin, :readers_plus]
    else
      render :edit
    end
  end
end
