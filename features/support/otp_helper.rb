require 'capybara/dsl'
require 'nokogiri'

module OtpHelper
  include Capybara::DSL

  # Fungsi untuk login ke dashboard admin
  # @param email [String] Email untuk login.
  # @param password [String] Password untuk login.
  def login_to_dashboard(email, password)
    puts "Logging into dashboard..."
    visit '/admin' # Asumsi halaman login ada di /admin
    fill_in 'admin_user_email', with: email
    fill_in 'admin_user_password', with: password
    click_button 'commit'
    # Validasi login berhasil
    expect(page).to have_css('li#history_log', wait: 10)
    puts "Login successful."
  end

  # Fungsi utama untuk login dan mengambil OTP berdasarkan nomor telepon.
  # @param phone_number [String] Nomor telepon yang akan dicari.
  # @return [String] Nilai OTP yang ditemukan, atau nil jika tidak ditemukan.
  def get_otp_from_dashboard(phone_number)
    # Anda bisa membuat langkah login ini menjadi hook `Before` atau step `Given` terpisah
    # untuk best practice, tapi untuk sementara kita letakkan di sini.
    unless page.has_css?('li#history_log') # Cek apakah sudah login
      login_to_dashboard(ENV['ADMIN_EMAIL'], ENV['ADMIN_PASSWORD'])
    end

    # 1. Navigasi ke halaman riwayat notifikasi
    puts "Navigating to histories page..."
    find('li#history_log > a').click
    find('li#histories > a').click
    
    # 2. Cari baris tabel berdasarkan nomor telepon
    puts "Searching for phone number: #{phone_number}"
    row_xpath = "//tr[td[contains(@class,'col-phone') and normalize-space(text())='#{phone_number}']]"
    
    unless page.has_xpath?(row_xpath, wait: 10)
      puts "Error: Phone number #{phone_number} not found on the page."
      return nil
    end
    
    row = find(:xpath, row_xpath)

    # 3. Ekstrak ID dari baris yang ditemukan
    history_id = row['id'].split('_').last
    unless history_id
      puts "Error: Could not extract history ID from the row."
      return nil
    end

    puts "Found history ID: #{history_id}. Navigating to details page..."

    # 4. Klik link detail untuk membuka halaman OTP
    # Menggunakan `within` untuk memastikan kita klik link di dalam baris yang benar
    within(row) do
      click_link(history_id)
    end
    
    # 5. Ekstrak OTP dari halaman detail
    otp_xpath = "//tr[th[text()='Token']]/td"
    unless page.has_xpath?(otp_xpath, wait: 10)
        puts "Error: OTP token not found on the details page."
        return nil
    end

    otp = find(:xpath, otp_xpath).text.strip
    puts "Successfully retrieved OTP: #{otp}"
    
    # Kembali ke halaman sebelumnya agar tidak mengganggu step selanjutnya
    page.go_back
    
    otp
  end
end

