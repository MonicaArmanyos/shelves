ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Book created last week" do
          table do
            Book.where('created_at <= ? and created_at >= ?', Time.now, 1.week.ago).map do |book|
              li link_to(book.name, admin_book_path(book))
            end
          end
        end
      end

      column do
        panel "Books are Not approved" do
          table do
            Book.where('is_approved = ? ', "NO").map do |book|
              li link_to(book.name, admin_book_path(book))
            end
          end  
        end
      end
    end
  end # content
end
