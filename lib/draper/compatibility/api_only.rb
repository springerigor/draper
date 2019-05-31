module Draper
  module Compatibility
    # Draper expects your `ApplicationController` to include `ActionView::Rendering`. The
    # `ApplicationController` generated by Rails 5 API-only applications (created with
    # `rails new --api`) don't by default. However, including `ActionView::Rendering` in
    # `ApplicatonController` breaks `render :json` due to `render_to_body` being overridden.
    #
    # This compatibility patch fixes the issue by restoring the original `render_to_body`
    # method after including `ActionView::Rendering`. Ultimately, including `ActionView::Rendering`
    # in an ActionController::API may not be supported functionality by Rails (see Rails issue
    # for more detail: https://github.com/rails/rails/issues/27211). This hack is meant to be a
    # temporary solution until we can find a way to not rely on the controller layer.
    module ApiOnly
      extend ActiveSupport::Concern

      included do
        alias_method :previous_render_to_body, :render_to_body
        include ActionView::Rendering
        alias_method :render_to_body, :previous_render_to_body
      end
    end
  end
end
