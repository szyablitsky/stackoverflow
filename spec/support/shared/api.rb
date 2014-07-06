RSpec.shared_examples 'prevents unauthorized access' do
  it 'returns 401 status if no access token provided' do
    do_request
    expect(response.status).to eq 401
  end

  it 'returns 401 status if invalid access token provided' do
    do_request(access_token: '123456')
    expect(response.status).to eq 401
  end
end
