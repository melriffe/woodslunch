require 'spec_helper'

describe 'Student orders' do

  let(:student) { FactoryGirl.create(:student) }
  let(:user) { student.user }

  before(:each) do
    # Given I am signed in
    sign_in_as(user)
  end

  context 'a signed in user with associated student' do

    it 'views order form for that student' do
      # When I go to the home page
      visit root_path

      # And I click on the student order link
      click_on "Lunch order for #{student.name}"

      # Then I should see the order form for that student
      page.should have_content(student.name)
    end
    
    it 'cannot view student order form for unassociated student' do
      pending
      # TODO: Implement similar to verify_admin
    end
  end

  describe 'when not signed in' do
    
    before(:each) do
      sign_out
    end

    describe 'GET /students/:student_id/:year/:month' do

      it 'redirects to sign in page' do
        visit edit_student_order_path(student, :year => '2011', :month => '4') 
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET /students/:student_id/orders/:year/:month' do

    let(:month) { '5' }
    let(:year) { '2011' }

    it 'displays month' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'May')]]")
    end

    it 'displays year' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'#{year}')]]")
    end

    it 'displays student name' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//*[@id='student_name']" + 
        "[text()[contains(.,'#{student.name}')]]")
    end

    it 'displays weekdays' do
      visit edit_student_order_path(student, :year => year, :month => month)
      DayOfWeek.weekdays.collect(&:name).each do |day|
        page.should have_content(day)
      end
    end

    context 'given a menu item served on Mondays' do
      let(:daily_menu_item) { 
        FactoryGirl.create(:daily_menu_item, 
          :day_of_week => DayOfWeek.find_by_name('Monday'))
      }

      it 'displays the menu item on each Monday'
    end
  end

  describe 'POST /students/:student_id/orders' do
 
    let(:month) { '6' }
    let(:year) { '2011' }   

    it 'creates an order' do
      pending

      # Given a menu item Hamburger served on Mondays
      menu_item = FactoryGirl.create(:menu_item, :name => 'Hamburger')
      FactoryGirl.create(:daily_menu_item, 
        :menu_item => menu_item,
        :day_of_week => DayOfWeek.find_by_name('Monday'))

      # When I go to the student order form
      visit edit_student_order_path(student, :year => year, :month => month)

      # And I check Hamburger for the first Monday
      within('td#6') do
        check 'Hamburger'
      end

      # And I click Place Order
      click_button 'Place Order'

      # Then I should see a successful order message
      
            
    end
  end
end
