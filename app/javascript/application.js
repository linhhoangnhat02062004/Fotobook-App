// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Global JavaScript for Fotobook Application
function initializeAllComponents() {
    console.log('Fotobook application loaded successfully!');
    
    // Initialize all components
    initializeNavigation();
    initializeAnimations();
    initializeFormValidation();
    initializeUploadAreas();
    initializeFeedTabs();
    initializeLikeButtons();
    initializePhotoModal();
    initializeStatsButtons();
    initializeSearchFunctionality();
    initializeSmoothScrolling();
    initializeAccessibility();
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeAllComponents);

// Initialize when Turbo loads new content
document.addEventListener('turbo:load', initializeAllComponents);

// Initialize when Turbo renders new content
document.addEventListener('turbo:render', initializeAllComponents);

// Initialize when page becomes visible (for browser back/forward)
document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
        setTimeout(initializeAllComponents, 100);
    }
});

// Navigation Dropdown Functionality
function initializeNavigation() {
    const dropdown = document.querySelector('.dropdown');
    const dropdownMenu = document.getElementById('dropdownMenu');
    
    if (!dropdown || !dropdownMenu) {
        console.log('Dropdown elements not found, skipping navigation initialization');
        return;
    }
    
    // Remove existing event listeners by cloning and replacing
    const newDropdown = dropdown.cloneNode(true);
    dropdown.parentNode.replaceChild(newDropdown, dropdown);
    
    // Get fresh references after cloning
    const freshDropdown = document.querySelector('.dropdown');
    const freshDropdownMenu = document.getElementById('dropdownMenu');
    
    if (!freshDropdown || !freshDropdownMenu) {
        console.log('Fresh dropdown elements not found');
        return;
    }
    
    let isAnimating = false;
    let animationTimeout = null;
    
    // Toggle dropdown with debouncing
    window.toggleDropdown = function() {
        // Prevent multiple rapid clicks
        if (isAnimating) {
            return;
        }
        
        const isVisible = freshDropdownMenu.style.display === 'block';
        
        if (!isVisible) {
            // Show dropdown
            isAnimating = true;
            freshDropdownMenu.style.display = 'block';
            freshDropdownMenu.style.opacity = '1';
            freshDropdownMenu.style.transform = 'scaleY(1)';
            
            // Reset animation flag after animation completes
            setTimeout(() => {
                isAnimating = false;
            }, 150);
        } else {
            // Hide dropdown
            isAnimating = true;
            freshDropdownMenu.style.opacity = '0';
            freshDropdownMenu.style.transform = 'scaleY(0)';
            
            // Clear any existing timeout
            if (animationTimeout) {
                clearTimeout(animationTimeout);
            }
            
            animationTimeout = setTimeout(() => {
                freshDropdownMenu.style.display = 'none';
                isAnimating = false;
                animationTimeout = null;
            }, 150);
        }
    };

    // Close dropdown when clicking outside with debouncing
    document.addEventListener('click', function(event) {
        if (!freshDropdown.contains(event.target)) {
            // Prevent multiple rapid calls
            if (isAnimating) {
                return;
            }
            
            isAnimating = true;
            freshDropdownMenu.style.opacity = '0';
            freshDropdownMenu.style.transform = 'scaleY(0)';
            
            // Clear any existing timeout
            if (animationTimeout) {
                clearTimeout(animationTimeout);
            }
            
            animationTimeout = setTimeout(() => {
                freshDropdownMenu.style.display = 'none';
                isAnimating = false;
                animationTimeout = null;
            }, 150);
        }
    });

    // Handle logout button clicks
    const logoutButtons = document.querySelectorAll('form[action*="sign_out"] button');
    logoutButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Show loading state
            const originalHTML = this.innerHTML;
            const isDropdownButton = this.closest('.dropdown-item') !== null;
            
            if (isDropdownButton) {
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-3"></i><div><div class="fw-medium">Đang đăng xuất...</div><small class="text-muted">Please wait</small></div>';
            } else {
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i><span class="d-none d-lg-inline">Đang đăng xuất...</span>';
            }
            
            this.disabled = true;
            
            // Re-enable after a delay in case of errors
            setTimeout(() => {
                this.innerHTML = originalHTML;
                this.disabled = false;
            }, 5000);
        });
    });
    
    console.log('Navigation initialized successfully');
}

// Animation Initialization
function initializeAnimations() {
    // Add fade-in animation to all cards
    const cards = document.querySelectorAll('.card');
    cards.forEach((card, index) => {
        card.style.animationDelay = `${index * 0.1}s`;
        card.classList.add('fade-in');
    });
}

// Form Validation
function initializeFormValidation() {
    const signupForm = document.getElementById('signupForm');
    if (signupForm) {
        const passwordInput = document.getElementById('user_password');
        const confirmPasswordInput = document.getElementById('user_password_confirmation');
        const emailInput = document.getElementById('user_email');
        const firstNameInput = document.getElementById('user_first_name');
        const lastNameInput = document.getElementById('user_last_name');
        const socialButtons = document.querySelectorAll('.social-btn');

        // Form validation
        function validateForm() {
            const firstName = firstNameInput ? firstNameInput.value.trim() : '';
            const lastName = lastNameInput ? lastNameInput.value.trim() : '';
            const email = emailInput ? emailInput.value.trim() : '';
            const password = passwordInput ? passwordInput.value : '';
            const confirmPassword = confirmPasswordInput ? confirmPasswordInput.value : '';

            // Reset previous error states
            clearErrors();

            let isValid = true;

            // Validate First Name
            if (firstName === '') {
                showError('user_first_name', 'Vui lòng nhập tên');
                isValid = false;
            } else if (firstName.length < 2) {
                showError('user_first_name', 'Tên phải có ít nhất 2 ký tự');
                isValid = false;
            }

            // Validate Last Name
            if (lastName === '') {
                showError('user_last_name', 'Vui lòng nhập họ');
                isValid = false;
            } else if (lastName.length < 2) {
                showError('user_last_name', 'Họ phải có ít nhất 2 ký tự');
                isValid = false;
            }

            // Validate Email
            if (email === '') {
                showError('user_email', 'Vui lòng nhập email');
                isValid = false;
            } else if (!isValidEmail(email)) {
                showError('user_email', 'Vui lòng nhập email hợp lệ');
                isValid = false;
            }

            // Validate Password
            if (password === '') {
                showError('user_password', 'Vui lòng nhập mật khẩu');
                isValid = false;
            } else if (password.length < 6) {
                showError('user_password', 'Mật khẩu phải có ít nhất 6 ký tự');
                isValid = false;
            }

            // Validate Password Confirmation
            if (confirmPassword === '') {
                showError('user_password_confirmation', 'Vui lòng xác nhận mật khẩu');
                isValid = false;
            } else if (password !== confirmPassword) {
                showError('user_password_confirmation', 'Mật khẩu xác nhận không khớp');
                isValid = false;
            }

            return isValid;
        }

        // Email validation function
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        // Show error message
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.style.color = '#dc3545';
            errorDiv.style.fontSize = '0.875rem';
            errorDiv.style.marginTop = '0.25rem';
            errorDiv.textContent = message;

            field.classList.add('is-invalid');
            field.parentNode.appendChild(errorDiv);
        }

        // Clear all errors
        function clearErrors() {
            const errorMessages = document.querySelectorAll('.error-message');
            const invalidFields = document.querySelectorAll('.is-invalid');

            errorMessages.forEach(error => error.remove());
            invalidFields.forEach(field => field.classList.remove('is-invalid'));
        }

        // Real-time validation
        function validatePasswordMatch() {
            const password = passwordInput ? passwordInput.value : '';
            const confirmPassword = confirmPasswordInput ? confirmPasswordInput.value : '';

            if (confirmPassword && password !== confirmPassword) {
                confirmPasswordInput.classList.add('is-invalid');
            } else {
                confirmPasswordInput.classList.remove('is-invalid');
            }
        }

        function validateEmail() {
            const email = emailInput ? emailInput.value.trim() : '';
            if (email && !isValidEmail(email)) {
                emailInput.classList.add('is-invalid');
            } else {
                emailInput.classList.remove('is-invalid');
            }
        }

        // Handle form submission
        signupForm.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                return false;
            }

            // Show loading state
            const submitBtn = signupForm.querySelector('.signup-btn');
            if (submitBtn) {
                const originalText = submitBtn.textContent;
                submitBtn.textContent = 'Đang đăng ký...';
                submitBtn.disabled = true;

                // Re-enable button after a delay in case of errors
                setTimeout(() => {
                    submitBtn.textContent = originalText;
                    submitBtn.disabled = false;
                }, 5000);
            }
        });

        // Show success message
        function showSuccessMessage() {
            const successDiv = document.createElement('div');
            successDiv.className = 'alert alert-success mt-3';
            successDiv.textContent = 'Đăng ký thành công! Chào mừng bạn đến với Fotobook!';
            
            signupForm.appendChild(successDiv);

            // Remove success message after 5 seconds
            setTimeout(() => {
                successDiv.remove();
            }, 5000);
        }

        // Real-time validation
        if (passwordInput) passwordInput.addEventListener('input', validatePasswordMatch);
        if (confirmPasswordInput) confirmPasswordInput.addEventListener('input', validatePasswordMatch);
        if (emailInput) emailInput.addEventListener('input', validateEmail);

        // Social login button handlers
        socialButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                
                const platform = this.classList.contains('google-btn') ? 'Google' :
                               this.classList.contains('facebook-btn') ? 'Facebook' :
                               'Twitter';
                
                // Add click animation
                this.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    this.style.transform = '';
                }, 150);

                // Show platform-specific message
                showSocialLoginMessage(platform);
            });
        });

        // Show social login message
        function showSocialLoginMessage(platform) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'alert alert-info mt-3';
            messageDiv.textContent = `Đang chuyển hướng đến đăng nhập ${platform}...`;
            
            const existingAlert = document.querySelector('.alert');
            if (existingAlert) {
                existingAlert.remove();
            }
            
            signupForm.appendChild(messageDiv);

            // Remove message after 3 seconds
            setTimeout(() => {
                messageDiv.remove();
            }, 3000);
        }
    }
}

// Upload Area Functionality
function initializeUploadAreas() {
    const uploadAreas = document.querySelectorAll('.upload-area');
    
    uploadAreas.forEach(uploadArea => {
        const imageInput = uploadArea.querySelector('input[type="file"]');
        const imagePreview = document.getElementById('imagePreview');
        const previewImage = document.getElementById('previewImage');
        const maxSize = 5 * 1024 * 1024; // 5MB

        if (uploadArea && imageInput) {
            // Drag and drop functionality
            uploadArea.addEventListener('dragover', function(e) {
                e.preventDefault();
                uploadArea.classList.add('dragover');
            });

            uploadArea.addEventListener('dragleave', function(e) {
                e.preventDefault();
                uploadArea.classList.remove('dragover');
            });

            uploadArea.addEventListener('drop', function(e) {
                e.preventDefault();
                uploadArea.classList.remove('dragover');
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    handleFile(files[0]);
                }
            });

            // File input change
            imageInput.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    handleFile(e.target.files[0]);
                }
            });

            function handleFile(file) {
                // Check file type
                if (!file.type.match('image.*')) {
                    alert('Please select an image file (JPEG, PNG, or GIF)');
                    return;
                }

                // Check file size
                if (file.size > maxSize) {
                    alert('File size must be less than 5MB');
                    return;
                }

                // Show preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    if (previewImage) {
                        previewImage.src = e.target.result;
                        if (imagePreview) {
                            imagePreview.style.display = 'block';
                            uploadArea.style.display = 'none';
                        }
                    }
                };
                reader.readAsDataURL(file);
            }

            // Remove image function
            window.removeImage = function() {
                if (imagePreview) imagePreview.style.display = 'none';
                uploadArea.style.display = 'flex';
                imageInput.value = '';
            };
        }
    });
}

// Feed Tab Functionality
function initializeFeedTabs() {
    const photosTab = document.getElementById('photos');
    const albumsTab = document.getElementById('albums');
    const photosFeed = document.getElementById('photosFeed');
    const albumsFeed = document.getElementById('albumsFeed');
    
    if (photosTab && albumsTab && photosFeed && albumsFeed) {
        photosTab.addEventListener('change', function() {
            photosFeed.style.display = 'block';
            albumsFeed.style.display = 'none';
        });
        
        albumsTab.addEventListener('change', function() {
            photosFeed.style.display = 'none';
            albumsFeed.style.display = 'block';
        });
    }
}

// Like Button Functionality
function initializeLikeButtons() {
    document.querySelectorAll('.like-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const photoId = this.dataset.photoId;
            const albumId = this.dataset.albumId;
            
            if (photoId) {
                // Like photo
                fetch(`/photos/${photoId}/like`, {
                    method: 'POST',
                    headers: {
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                    }
                });
            } else if (albumId) {
                // Like album
                fetch(`/albums/${albumId}/like`, {
                    method: 'POST',
                    headers: {
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                    }
                });
            }
            
            this.classList.toggle('liked');
        });
    });
}

// Photo Modal Functionality
function initializePhotoModal() {
    const photoModal = document.getElementById('photoModal');
    if (photoModal) {
        photoModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const photoId = button.dataset.photoId;
            
            // Load photo content
            fetch(`/photos/${photoId}`)
                .then(response => response.text())
                .then(html => {
                    const modalContent = document.getElementById('modalPhotoContent');
                    if (modalContent) {
                        modalContent.innerHTML = html;
                    }
                });
        });
    }
}

// Stats Buttons Functionality
function initializeStatsButtons() {
    const statsButtons = document.querySelectorAll('.stats-btn');
    const contentSections = document.querySelectorAll('.content-section');
    
    if (statsButtons.length > 0) {
        console.log('Stats buttons found:', statsButtons.length);
        
        statsButtons.forEach(button => {
            button.addEventListener('click', function() {
                const contentType = this.getAttribute('data-content');
                console.log('Clicked button:', contentType);
                
                // Remove active class from all buttons
                statsButtons.forEach(btn => {
                    btn.classList.remove('active');
                    console.log('Removed active from:', btn.getAttribute('data-content'));
                });
                
                // Add active class to clicked button
                this.classList.add('active');
                console.log('Added active to:', contentType);
                
                // Hide all content sections
                contentSections.forEach(section => {
                    section.style.display = 'none';
                });
                
                // Show selected content section
                const targetSection = document.getElementById(contentType + '-content');
                if (targetSection) {
                    targetSection.style.display = 'block';
                    console.log('Showing section:', contentType + '-content');
                }
            });
        });
    }
}

// Search Functionality
function initializeSearchFunctionality() {
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const searchTerm = this.value.trim();
                if (searchTerm) {
                    showSearchMessage(searchTerm);
                }
            }
        });
    }

    function showSearchMessage(searchTerm) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'alert alert-info position-fixed';
        messageDiv.style.top = '80px';
        messageDiv.style.right = '20px';
        messageDiv.style.zIndex = '1000';
        messageDiv.textContent = `Đang tìm kiếm: "${searchTerm}"`;
        
        document.body.appendChild(messageDiv);

        // Remove message after 3 seconds
        setTimeout(() => {
            messageDiv.remove();
        }, 3000);
    }
}

// Smooth Scrolling
function initializeSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Accessibility Features
function initializeAccessibility() {
    // Add focus effects for better accessibility
    const formInputs = document.querySelectorAll('.form-control');
    formInputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentNode.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            this.parentNode.classList.remove('focused');
        });
    });

    // Add keyboard navigation support
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Tab') {
            document.body.classList.add('keyboard-navigation');
        }
    });

    document.addEventListener('mousedown', function() {
        document.body.classList.remove('keyboard-navigation');
    });
}

// Auto-hide alerts after 5 seconds
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        const bsAlert = new bootstrap.Alert(alert);
        bsAlert.close();
    });
}, 5000);

// Legacy Functions (keeping for compatibility)
const photoContent = "<h4>Photo Content</h4><p>Here you can put your photo content.</p>";
const albumContent = "<h4>Album Content</h4><p>Here you can put your album content.</p>";

// Function to update the content based on clicked tab
document.addEventListener('DOMContentLoaded', function() {
    const photoTab = document.getElementById('photo-tab');
    const albumTab = document.getElementById('album-tab');
    const content = document.getElementById('content');
    
    if (photoTab && content) {
        photoTab.addEventListener('click', function() {
            content.innerHTML = photoContent;
        });
    }
    
    if (albumTab && content) {
        albumTab.addEventListener('click', function() {
            content.innerHTML = albumContent;
        });
    }
    
    // Default content (e.g., Photo) will be rendered initially
    if (content) {
        content.innerHTML = photoContent;
    }
});

// Admin Dropdown Enhancement - Đơn giản hóa
function initializeAdminDropdown() {
    // Chỉ đảm bảo Bootstrap dropdown hoạt động
    const dropdownElement = document.querySelector('[data-bs-toggle="dropdown"]');
    
    if (dropdownElement && window.bootstrap && window.bootstrap.Dropdown) {
        // Khởi tạo Bootstrap dropdown nếu chưa có
        if (!window.bootstrap.Dropdown.getInstance(dropdownElement)) {
            new window.bootstrap.Dropdown(dropdownElement, {
                autoClose: true
            });
        }
    }
}

// Initialize admin dropdown when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeAdminDropdown);
document.addEventListener('turbo:load', initializeAdminDropdown);

// Thêm một cách đơn giản để đảm bảo dropdown hoạt động
document.addEventListener('click', function(e) {
    if (e.target.closest('[data-bs-toggle="dropdown"]')) {
        setTimeout(initializeAdminDropdown, 1);
    }
});