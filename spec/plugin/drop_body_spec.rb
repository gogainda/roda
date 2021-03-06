require_relative "../spec_helper"

describe "drop_body plugin" do 
  it "automatically drops body and Content-Type/Content-Length headers for responses without a body" do
    app(:drop_body) do |r|
      response.status = r.path.to_i
      response.write('a')
    end

    [101, 102, 204, 304].each do  |i|
      body(i.to_s).must_equal ''
      header('Content-Type', i.to_s).must_be_nil
      header('Content-Length', i.to_s).must_be_nil
    end

    body('205').must_equal ''
    header('Content-Type', '205').must_be_nil
    header('Content-Length', '205').must_equal '0'

    body('200').must_equal 'a'
    header('Content-Type', '200').must_equal 'text/html'
    header('Content-Length', '200').must_equal '1'
  end
end
