require "cuttlekit/version"

module Cuttlekit
  class Committer
    public
      def commit(user, dir, path = '')
        #TODO: clean up params to (user, path, dir, root_repo = false)
        @api = user
        @dir = dir
        @path = path
        @repo_url = @path
        @root_repo = !@path.empty?
        @repo = commit_new_jekyll
        { repo: @repo, branch_name: branch_name }
      end

    private
      def commit_new_jekyll
        repo = @api.create_repository(@repo_url, auto_init: true)
        repo_info = create_repo_object(repo)
        last_sha = scan_folder(@dir, repo_info)
        finalize_repo(last_sha, repo_info)

        repo
      end

      def create_repo_object(repo)
        full_repo_path = repo.full_name
        sha_latest_commit = create_refs(full_repo_path)
        sha_base_tree = @api.commit(full_repo_path, sha_latest_commit).commit.tree.sha

        repo_info = Struct.new(:full_repo_path, :sha_latest_commit, :sha_base_tree)
        repo_info.new(full_repo_path, sha_latest_commit, sha_base_tree)
      end

      def create_refs(full_repo_path)
        @ref = 'heads/feature'

        sha_latest_commit = @api.ref(full_repo_path, 'heads/master').object.sha
        @api.create_ref(full_repo_path, 'heads/gh-pages', sha_latest_commit) if @root_repo != true
        @api.create_ref(full_repo_path, @ref, sha_latest_commit).object.sha
      end

      # (dir, full_repo_path, sha_latest_commit, sha_base_tree)
      def scan_folder(dir, repo)
        @latest_sha = repo.sha_latest_commit
        Dir.foreach(dir) do |item|
          next if item == '.' || item == '..'
          full_path = File.expand_path(item, dir)
          puts "DIR! #{full_path}" if File.directory?(full_path)
          scan_folder(full_path, repo) if File.directory?(full_path)
          next if File.directory?(full_path)
          repo.sha_latest_commit = @api.ref(repo.full_repo_path, @ref).object.sha ###### here
          repo.sha_base_tree = @api.commit(repo.full_repo_path, repo.sha_latest_commit).commit.tree.sha

          sha_new_commit = create_commit(item, dir, repo)
          @latest_sha = sha_new_commit
        end
        @latest_sha
      end

      def create_commit(file, dir, repo)
        full_path = File.expand_path(file, dir)

        remote_path = full_path.gsub(@dir + '/', '')
        blob_sha = @api.create_blob(repo.full_repo_path, Base64.encode64(File.read(full_path)), 'base64')
        sha_new_tree = @api.create_tree(repo.full_repo_path,
                                        [{ path: remote_path,
                                           mode: '100644',
                                           type: 'blob',
                                           sha: blob_sha }],
                                        base_tree: repo.sha_base_tree).sha
        commit_message = "Creates #{remote_path}"
        puts "committing: #{full_path}"
        sha_new_commit = @api.create_commit(repo.full_repo_path, commit_message, sha_new_tree, repo.sha_latest_commit).sha
        @api.update_ref(repo.full_repo_path, @ref, sha_new_commit)
        sha_new_commit
      end

      def finalize_repo(last_sha, repo)
        # Edits repo description and merges temporary branch into master or gh-pages

        @api.update_branch(repo.full_repo_path, @ref.gsub('heads/', ''), last_sha)
        @api.edit_repository(repo.full_repo_path, default_branch: branch_name)

        @api.merge(repo.full_repo_path, "#{branch_name}", 'feature')
      end

      def full_repo_url
        proto = 'https://'
        return proto + @repo_url if @root_repo
        proto + @api.login + '.github.io/' + @repo_url + '/'
      end

      def branch_name
        return 'gh-pages' unless @path.empty?
        'master'
      end
    end
end
