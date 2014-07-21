module ApiMacros
  def expect_json_val(val, path)
    expect(response.body).to be_json_eql(val).at_path(path)
  end

  def expect_json_size(size, path)
    expect(response.body).to have_json_size(size).at_path(path)
  end
end
