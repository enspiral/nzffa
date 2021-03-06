ActionController::Routing::Routes.draw do |map|
  map.branch_admin '/branch_admin/:group_id.:format', :controller => :branch_admin, :action => :index
  map.branch_admin_past_members '/branch_admin/:group_id/past_members.:format', :controller => :branch_admin, :action => :past_members
  map.branch_admin_last_year_members '/branch_admin/:group_id/last_year_members.:format', :controller => :branch_admin, :action => :last_year_members
  map.branch_admin_past_fft_members '/branch_admin/:group_id/past_fft_members', :controller => :branch_admin, :action => :past_fft_members

  map.branch_admin_email '/branch_admin/:group_id/email', :controller => :branch_admin, :action => :email
  map.branch_admin_edit '/branch_admin/:group_id/edit/:nzffa_membership_id', :controller => :branch_admin, :action => :edit
  map.branch_admin_update '/branch_admin/:group_id/update/:nzffa_membership_id', :controller => :branch_admin, :action => :update

  map.resources :subscriptions, :except => [:destroy, :edit, :update],
    :collection => { :quote_new => :post,
                     :quote_upgrade => :post,
                     :modify => :get,
                     :upgrade => :put,
                     :renew => :get,
                     :cancel => :post}

  map.resources :adverts,
    :collection => {
      :edit_company_listing => :get,
      :index_table => :get,
      :my_adverts => :get,
    },
    :member => {
      :renew => :put,
      :email => [:get]
    }

  map.resources :orders, :only => [],
    :member => { :make_payment => :get},
    :collection => { :payment_finished => :get }

  map.membership_details '/membership/details', :controller => :membership, :action => :details
  map.register_membership '/membership/register', :controller => :membership, :action => :register

  map.join_fft_button '/membership/join-fft-button', :controller => :membership, :action => :join_fft_button
  map.join_fft '/membership/join-fft', :controller => :membership, :action => :join_fft

  map.namespace :admin do |admin|
    admin.resources :reports, :only => :index, :collection => {:past_members_no_subscription => :get, 
                                                               :payments => :get, 
                                                               :allocations => :get, 
                                                               :members => :get, 
                                                               :deliveries => :get, 
                                                               :expiries => :get}
    admin.resources :subscriptions,
      :member     => { :print => :get,
                       :print_form => :get,
                       :print_renewal => :get,
                       :renew => :get },
      :collection => { :batches_to_print => :get,
                       :print_batch => :get}

    admin.resources :adverts
    admin.resources :readers_plus, :except => [:new, :create], :member => [:create_user]
    admin.resources :orders
    admin.resources :readers, :only => [] do |readers|
      readers.resources :orders, :only => :index
      readers.resources :subscriptions, :member => { :cancel => :post }
    end
  end

  map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"
  map.person_login "person_login", :controller => "person_sessions", :action => "new"
  map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
  map.resources :person_sessions
  map.new_reader "/become-a-member", :controller => 'membership', :action => 'register'
end
