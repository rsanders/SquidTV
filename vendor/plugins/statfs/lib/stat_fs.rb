
#
# This will only work on OS X.  It uses the 32-bit variant of the statfs structure, so
# it should work on both Leopard and Snow Leopard.
#
# Robert Sanders, robert@curioussquid.com
#

require 'ffi'

module StatFS
  extend FFI::Library
  ffi_lib FFI::Library::LIBC

  class FSID < FFI::Struct
    layout :val, [:int32, 2]
  end

  # typedef FSID, :fsid_t

  FLAG_MNT_RDONLY = 0x00000001
  FLAG_MNT_LOCAL = 0x00001000
  FLAG_MNT_ROOTFS = 0x00004000
  FLAG_MNT_AUTOMOUNTED = 0x00400000

  typedef :int32, :uid_t

  class StatFSStruct < FFI::Struct

    MFSNAMELEN = 15
    MNAMELEN = 90

    layout :f_otype, :short,
      :f_oflags, :short,
      :f_bsize, :long,
      :f_iosize, :long,
      :f_blocks, :long,
      :f_bfree, :long,
      :f_bavail, :long,
      :f_files, :long,
      :f_ffree, :long,
      :f_fsid, FSID,
      :f_owner, :uid_t,
      :f_reserved1, :short,
      :f_type, :short,
      :f_flags, :long,
      :f_reserved2, [:long, 2],
      :f_fstypename, [:uchar, MFSNAMELEN],
      :f_mntonname, [:uchar, MNAMELEN],
      :f_mntfromname, [:uchar, MNAMELEN],
      # just in case
      :buf, [:int32, 512]

    def read_c_string(field)
      array = self[field]
      "".tap do |str|
        for i in 0..array.size-1
          byte = array[i]
          break if byte == 0
          str << byte
        end
      end
    end

    def f_fstypename
      read_c_string(:f_fstypename)
    end

    def f_mntonname
      read_c_string(:f_mntonname)
    end

    def f_mntfromname
      read_c_string(:f_mntfromname)
    end

    def method_missing(name, *args)
      self[name]
    end

    def local?
      self[:f_flags] & FLAG_MNT_LOCAL != 0
    end
  end

  attach_function 'statfs', [ :string, :pointer], :int

  class << self
    alias_method :statfs_raw, :statfs

    def statfs(path)
      struct = StatFSStruct.new
      statfs_raw(path, struct)
      struct
    end
  end
end

#DESCRIPTION
#     The statfs() routine returns information about a mounted file system.  The path argument is the
#     path name of any file or directory within the mounted file system.  The buf argument is a pointer
#     to a statfs structure.  When the macro _DARWIN_FEATURE_64_BIT_INODE is not defined (the ino_t
#     type is 32-bits), that structure is defined as:
#
#     typedef struct { int32_t val[2]; } fsid_t;
#
#     #define MFSNAMELEN      15 /* length of fs type name, not inc. nul */
#     #define MNAMELEN        90 /* length of buffer for returned name */
#
#     struct statfs { /* when _DARWIN_FEATURE_64_BIT_INODE is NOT defined */
#         short   f_otype;    /* type of file system (reserved: zero) */
#         short   f_oflags;   /* copy of mount flags (reserved: zero) */
#         long    f_bsize;    /* fundamental file system block size */
#         long    f_iosize;   /* optimal transfer block size */
#         long    f_blocks;   /* total data blocks in file system */
#         long    f_bfree;    /* free blocks in fs */
#         long    f_bavail;   /* free blocks avail to non-superuser */
#         long    f_files;    /* total file nodes in file system */
#         long    f_ffree;    /* free file nodes in fs */
#         fsid_t  f_fsid;     /* file system id */
#         uid_t   f_owner;    /* user that mounted the file system */
#         short   f_reserved1;        /* reserved for future use */
#         short   f_type;     /* type of file system (reserved) */
#         long    f_flags;    /* copy of mount flags (reserved) */
#         long    f_reserved2[2];     /* reserved for future use */
#         char    f_fstypename[MFSNAMELEN]; /* fs type name */
#         char    f_mntonname[MNAMELEN];    /* directory on which mounted */
#         char    f_mntfromname[MNAMELEN];  /* mounted file system */
#     char    f_reserved3;        /* reserved for future use */
#     long    f_reserved4[4];     /* reserved for future use */
# };
#
# However, when the macro _DARWIN_FEATURE_64_BIT_INODE is defined, the ino_t type will be 64-bits
# (force 64-bit inode mode by defining the _DARWIN_USE_64_BIT_INODE macro before including header
# files).  This will cause symbol variants of the statfs family, with the $INODE64 suffixes, to be
# automatically linked in.  In addition, the statfs structure will now be defined as:
#
# #define MFSTYPENAMELEN  16 /* length of fs type name including null */
# #define MAXPATHLEN      1024
# #define MNAMELEN        MAXPATHLEN
#
# struct statfs { /* when _DARWIN_FEATURE_64_BIT_INODE is defined */
#     uint32_t    f_bsize;        /* fundamental file system block size */
#     int32_t     f_iosize;       /* optimal transfer block size */
#     uint64_t    f_blocks;       /* total data blocks in file system */
#     uint64_t    f_bfree;        /* free blocks in fs */
#     uint64_t    f_bavail;       /* free blocks avail to non-superuser */
#     uint64_t    f_files;        /* total file nodes in file system */
#     uint64_t    f_ffree;        /* free file nodes in fs */
#     fsid_t      f_fsid;         /* file system id */
#     uid_t       f_owner;        /* user that mounted the filesystem */
#     uint32_t    f_type;         /* type of filesystem */
#     uint32_t    f_flags;        /* copy of mount exported flags */
#     uint32_t    f_fssubtype;    /* fs sub-type (flavor) */
#     char        f_fstypename[MFSTYPENAMELEN];   /* fs type name */
#     char        f_mntonname[MAXPATHLEN];        /* directory on which mounted */
#     char        f_mntfromname[MAXPATHLEN];      /* mounted filesystem */
#     uint32_t    f_reserved[8];  /* For future use */
# };
