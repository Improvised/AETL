class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :check_session
  COUNT_PER_PAGE = 20

########___________  
  
 
  def job_folder_linker(project)
    
    ## passes the AE Job ID to our method and extracts the jobs Year and Number
    folder_year = project.ae_job_id.to_s[0,4]    
    job_extract = project.ae_job_id.to_s[5,8]
    job_extract_int = job_extract.to_i
    ## subtracts 1 from the job number since we put, for example, job 0200 in a folder with all the 100's  
    job_extract_int_mun1 = job_extract_int - 1

    ## This figures out which sub-folder the job is in and then adds zeros if needed ("cenfolder")
    job_extract_front_int = job_extract_int_mun1 % 100 == 0 ? job_extract_int_mun1 : job_extract_int_mun1 - (job_extract_int_mun1 % 100)
    job_extract_back_int = job_extract_int % 100 == 0 ? job_extract_int : job_extract_int + 100 - (job_extract_int % 100)

    if job_extract_front_int < 10
      job_extract_front = "000" + job_extract_front_int.next.to_s
      elsif job_extract_front_int < 100
      job_extract_front = "00" + job_extract_front_int.next.to_s
      elsif job_extract_front_int < 1000
      job_extract_front = "0" + job_extract_front_int.next.to_s
      else
      job_extract_front = job_extract_front_int.next.to_s
    end

    if job_extract_back_int < 10
      job_extract_back = "000" + job_extract_back_int.to_s
      elsif job_extract_back_int < 100
      job_extract_back = "00" + job_extract_back_int.to_s
      elsif job_extract_back_int < 1000
      job_extract_back = "0" + job_extract_back_int.to_s
      else
      job_extract_back = job_extract_back_int.to_s
    end

    cenfolder = "Jobs " + job_extract_front + "-" + job_extract_back
   
    ## This finds all the folders that use our AE Job ID for the above 
    ## job number (should only be one) and finds it's full name.  That name is passed
    ## along.
    cur_job_folder = "public/ae_jobs/" + folder_year + "/" + cenfolder + "/"
    job_folder_front = project.ae_job_id.to_s
    job_folder = Dir.glob(cur_job_folder + job_folder_front + "*/")     
    ## Though if more than one folder does exist, only the last folder is used here.
    cl_job_folder = job_folder[-1]


    ## This just makes sure the folder does exist; if not, the link is empty-ish.
    if cl_job_folder == nil
     job_folder =  root_url.to_s + "nofolder.html"  #http://ae-task-loci.artisticengineering.com/nofolder.html"  
    else     
     client_ip = request.remote_ip
     
     if client_ip[0,3] == "192"
       job_folder_linker = "file://///Ae-datapool/ae" + job_folder[-1]
       job_folder_linker2 = job_folder_linker.gsub("public/ae_jobs/", "")
      else     
       job_folder_linker = "ftp://108.80.75.105/AE" + job_folder[-1]
       job_folder_linker2 = job_folder_linker.gsub("public/ae_jobs/", "")
     end
     
     job_folder = job_folder_linker2.gsub("#", "%23")     
    end
   ## Just so we're sure!!
   return job_folder
  end

########___________
   
  def pdf_linker(project)
    
    ## passes the AE Job ID to our method and extracts the jobs Year and Number
    folder_year = project.ae_job_id.to_s[0,4]    
    job_extract = project.ae_job_id.to_s[5,8]
    job_extract_int = job_extract.to_i
    ## subtracts 1 from the job number since we put, for example, job 0200 in a folder with all the 100's  
    job_extract_int_mun1 = job_extract_int - 1

    ## This figures out which sub-folder the job is in and then adds zeros if needed ("cenfolder")
    job_extract_front_int = job_extract_int_mun1 % 100 == 0 ? job_extract_int_mun1 : job_extract_int_mun1 - (job_extract_int_mun1 % 100)
    job_extract_back_int = job_extract_int % 100 == 0 ? job_extract_int : job_extract_int + 100 - (job_extract_int % 100)

    if job_extract_front_int < 10
      job_extract_front = "000" + job_extract_front_int.next.to_s
      elsif job_extract_front_int < 100
      job_extract_front = "00" + job_extract_front_int.next.to_s
      elsif job_extract_front_int < 1000
      job_extract_front = "0" + job_extract_front_int.next.to_s
      else
      job_extract_front = job_extract_front_int.next.to_s
    end

    if job_extract_back_int < 10
      job_extract_back = "000" + job_extract_back_int.to_s
      elsif job_extract_back_int < 100
      job_extract_back = "00" + job_extract_back_int.to_s
      elsif job_extract_back_int < 1000
      job_extract_back = "0" + job_extract_back_int.to_s
      else
      job_extract_back = job_extract_back_int.to_s
    end

    cenfolder = job_extract_front + "-" + job_extract_back
   
    ## This finds all the files in the folder with that use our AE Job ID for the above 
    ## job number (should only be one) and finds it's full name.  That name is passed
    ## along.
    cur_pdf_folder = "public/pdfs/client_req/" + folder_year + "/" + cenfolder + "/"
    pdf_file_front = project.ae_job_id.to_s
    pdf_files = Dir.glob(cur_pdf_folder + pdf_file_front + "*.pdf")     
    ## Though if more than one file does exist, only the first file is used here.
    cl_pdf_file = pdf_files[0]


    ## This just makes sure the file does exist; if not, the link is empty-ish.
    if cl_pdf_file == nil
     pdf_link = root_url.to_s + "nopdf.html"  #"http://ae-task-loci.artisticengineering.com/nopdf.html"
    else
     pdf_linker = root_url.to_s + pdf_files[0]
     pdf_link = pdf_linker.gsub("public/", "")
    end
   ## Just so we're sure!!
   return pdf_link
  end

########___________  

  private
  def check_session
    if session[:user].blank? or session[:user][:status] == "EWAUSER"
      redirect_to login_url
    end
  end
  
  def check_session_ewa
    if session[:user].blank?
      redirect_to login_url
    end
  end

  def fix_format_date(parameter)
    unless parameter[:date_in].blank?
      date_in = parameter[:date_in].split('-')
      parameter[:date_in] = date_in[2] + "-" + date_in[0] + "-" + date_in[1]
    end
    unless parameter[:due_date].blank?
      due_date = parameter[:due_date].split('-')
      parameter[:due_date] = due_date[2] + "-" + due_date[0] + "-" + due_date[1]
    end

    return parameter
  end

  def fix_format_time_of_day_shot(parameter)
    result = ""
    unless parameter.blank?
      time = parameter.split(' ')[1]
      date = parameter.split(' ')[0].split('-')
      result = date[2] + "-" + date[0] + "-" + date[1] + " " + time
    end
  	return result
	end 


  protected

  # def self.active_scaffold_controller_for(klass)
  #   # return FooController if klass == Bar
  #   return "Admin::#{klass}ScaffoldController".constantize rescue super
  # end
end
