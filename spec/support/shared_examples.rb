shared_examples "form with preserved fields" do
  it 're-renders form with preserved fields' do
    expect(page).to have_content("Create new expense")
    expect(page).to have_field("Enter Title", with: expected_title)
    expect(page).to have_field("Enter value", with: expected_value)
    
    if expected_date.present?
      expect(page).to have_field("Enter date",with: expected_date)
    else 
      expect(page).to have_field("Enter date")
      expect(find('input[name="expense[spent_on]"]').value).to be_nil
    end
  end
end