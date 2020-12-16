require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  test 'offer should belong to user and company' do
    user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
    user.save

    offer = Offer.new(student_id: 1, company_id: 1)
    assert offer.invalid?

    Student.new(user_id: 1, fullname: 'a', departament: 'a', group: 'a', wish: 'a').save
    offer = Offer.new(student_id: 1, company_id: 1)
    assert offer.invalid?

    Company.new(user_id: 1, name: 'a', vacancy: 'a', requirements: 'a', conditions: 'a').save
    offer = Offer.new(student_id: 1, company_id: 1)
    assert offer.valid?
  end
end
